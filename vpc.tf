module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = data.aws_availability_zones.available.names
  private_subnets = var.private_subnet_id
  public_subnets  = var.public_subnet_id
  private_subnet_tags = {
    "karpenter.sh/discovery" = var.cluster_name
    "kubernetes.io/role/internal-elb" = 1
  }
  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }
  enable_nat_gateway = true
}
