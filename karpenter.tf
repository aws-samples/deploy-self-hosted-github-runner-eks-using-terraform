
module "eks_blueprints_addon" {
  source           = "aws-ia/eks-blueprints-addon/aws"
  version          = "~> 1.1.1" #ensure to update this to the latest/desired version
  wait             = true
  wait_for_jobs    = true
  chart            = "karpenter"
  chart_version    = "0.37.0"
  repository       = "oci://public.ecr.aws/karpenter"
  description      = "Kubernetes Node Autoscaling: built for flexibility, performance, and simplicity"
  namespace        = "karpenter"
  create_namespace = true
  depends_on       = [module.eks]
  set = [
    {
      name  = "settings.clusterName"
      value = module.eks.cluster_name
    },
    {
      name  = "settings.clusterEndpoint"
      value = module.eks.cluster_endpoint
    }
  ]

  set_irsa_names = ["serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"]
  # # Equivalent to the following but the ARN is only known internally to the module
  # set = [{
  #   name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
  #   value = iam_role_arn.this[0].arn
  # }]

  # IAM role for service account (IRSA)
  create_role          = true
  role_name_use_prefix = false
  role_name            = "karpenter-controller-${module.eks.cluster_name}"
  role_policies = {
    karpenter = aws_iam_policy.karpenter_policy.arn
  }

  oidc_providers = {
    this = {
      provider_arn = module.eks.oidc_provider_arn
      # namespace is inherited from chart
      service_account = "karpenter"
    }
  }

  tags = {
    Environment = "dev"
  }
}

data "template_file" "karpenter_irsa_policy" {
  template = file("policy.json")
  vars = {
    cluster_name                 = module.eks.cluster_name
    node_name                    = local.managed_node_name
    account_id                   = data.aws_caller_identity.current.id
    region_name                  = data.aws_region.current.name
    managed_node_group_role_name = local.managed_node_group_iam_role_name
  }
}

resource "aws_iam_policy" "karpenter_policy" {
  name        = "${var.cluster_name}-karpenter-sa-policy"
  description = "Policy for Karpenter service account"
  policy      = data.template_file.karpenter_irsa_policy.rendered
}

locals {
  node_pools = {
    for pool_name, pool_config in var.runner_set_parameters : pool_name => {
      node-pool-name = pool_config.node-pool-name
      instance_type  = pool_config.instance_type
    }
  }
}

data "template_file" "node_pool" {
  for_each = local.node_pools
  template = file("nodepool.tpl")
  vars     = each.value
}

resource "null_resource" "deploy_node_pool" {
  for_each = data.template_file.node_pool

  triggers = {
    manifest = each.value.rendered
  }

  provisioner "local-exec" {
    command = "echo '${each.value.rendered}' | kubectl apply -f -"
  }

  depends_on = [
    module.eks,
    module.eks_blueprints_addon
  ]
}

data "template_file" "node_class" {
  template = file("nodeclass.tpl")
  vars = {
    cluster_name = module.eks.cluster_name
    role_name    = local.managed_node_group_iam_role_name
  }
}

resource "null_resource" "deploy_node_class" {
  triggers = {
    manifest = data.template_file.node_class.rendered
  }
  provisioner "local-exec" {
    command = "echo '${data.template_file.node_class.rendered}' | kubectl apply -f -"
  }

  depends_on = [
    module.eks,
    module.eks_blueprints_addon
  ]
}

