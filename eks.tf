
module "eks" {
  source                                   = "terraform-aws-modules/eks/aws"
  version                                  = "~> 20.0"
  depends_on                               = [module.vpc]
  cluster_name                             = var.cluster_name
  cluster_version                          = var.kubernetes_version
  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true
  iam_role_use_name_prefix                 = false
  iam_role_name                            = "${var.cluster_name}-role"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  tags       = var.tags
  eks_managed_node_groups = {
    managed_ng = {
      name                     = local.managed_node_group_name
      iam_role_use_name_prefix = false
      iam_role_name            = local.managed_node_group_iam_role_name
      instance_types           = var.instance_type
      min_size                 = var.min_size
      max_size                 = var.max_size
      desired_size             = var.desired_size
      create_launch_template   = false
      launch_template_id       = aws_launch_template.node_group_launch_template.id
      launch_template_version  = aws_launch_template.node_group_launch_template.latest_version

      iam_role_additional_policies = {
        AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      }
      tags = {
        "Environment" = "dev"
        "Name"        = "${var.cluster_name}-node"
        "Team"        = "DevOps"
      }
    }
  }
  # EKS Addons
  cluster_addons = {
    coredns    = {}
    kube-proxy = {}
    vpc-cni    = {}
  }
}

resource "aws_launch_template" "node_group_launch_template" {
  name                   = "${var.cluster_name}-launch-template"
  description            = var.launch_template_description
  update_default_version = true
  network_interfaces {
    associate_public_ip_address = false
  }

  block_device_mappings {
    device_name = var.ebs_device_name
    ebs {
      volume_size           = var.ebs_volume_size
      delete_on_termination = var.ebs_delete_on_termination
      volume_type           = var.ebs_volume_type
      iops                  = var.ebs_volume_iops
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags          = merge({ "Name" = local.managed_node_name }, var.tags)
  }
  tag_specifications {
    resource_type = "volume"
    tags          = merge({ "Name" = local.managed_node_name }, var.tags)
  }
  tags = merge({ "Name" = local.launch_template_name }, var.tags)
}

resource "aws_ec2_tag" "node_security_group_tag" {
  resource_id = module.eks.cluster_primary_security_group_id
  key         = "karpenter.sh/discovery"
  value       = module.eks.cluster_name
}

resource "null_resource" "configure_kubectl" {

  triggers = {
    cluster_endpoint = module.eks.cluster_endpoint
  }

  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${var.cluster_name} --region ${var.region}"
  }

  depends_on = [module.eks]
}
