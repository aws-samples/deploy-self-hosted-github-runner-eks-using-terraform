data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}
data "aws_availability_zones" "available" {
  state = "available"
}
