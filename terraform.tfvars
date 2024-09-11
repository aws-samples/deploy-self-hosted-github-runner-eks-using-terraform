cluster_name      = "my-eks-cluster-apg"
private_subnet_id = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
public_subnet_id  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
vpc_cidr          = "10.0.0.0/16"
vpc_name          = "my-vpc-apg"

kubernetes_version = "1.30"
region             = "us-east-1"

pat_secret_name = "ghapat"

runner_set_parameters = {
  eks-small-apg = {
    githubConfigUrl = "<Provide GitHub repository URL>"
    minRunners      = 2
    maxRunners      = 4
    node-pool-name  = "eks-small-apg"
    instance_type   = "t2.large"
    cpu             = 1
    memory          = "2Gi"
  }
  eks-medium-apg = {
    githubConfigUrl = "<Provide GitHub repository URL>"
    minRunners      = 1
    maxRunners      = 4
    node-pool-name  = "eks-medium-apg"
    instance_type   = "t2.xlarge"
    cpu             = 1
    memory          = "4Gi"
  }
  eks-large-apg = {
    githubConfigUrl = "<Provide GitHub repository URL>"
    minRunners      = 1
    maxRunners      = 4
    node-pool-name  = "eks-large-apg"
    instance_type   = "t2.2xlarge"
    cpu             = 2
    memory          = "8Gi"
  }
}
