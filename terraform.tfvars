cluster_name      = "my-eks-cluster"
private_subnet_id = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
public_subnet_id  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
vpc_cidr          = "10.0.0.0/16"
vpc_name          = "my-vpc-apg"

kubernetes_version = "1.30"
region             = "us-west-2"

pat_secret_name = "mypat"

runner_set_parameters = {
  eks-small = {
    githubConfigUrl = "https://github.com/sandipgangapadhyay/githubactiontest"
    minRunners      = 1
    maxRunners      = 4
    node-pool-name  = "eks-small"
    instance_type   = "t2.large"
    cpu             = 1
    memory          = "2Gi"
  }
  eks-medium = {
    githubConfigUrl = "https://github.com/sandipgangapadhyay/githubactiontest"
    minRunners      = 1
    maxRunners      = 4
    node-pool-name  = "eks-medium"
    instance_type   = "t2.xlarge"
    cpu             = 1
    memory          = "4Gi"
  }
  eks-large = {
    githubConfigUrl = "https://github.com/sandipgangapadhyay/githubactiontest"
    minRunners      = 1
    maxRunners      = 4
    node-pool-name  = "eks-large"
    instance_type   = "t2.2xlarge"
    cpu             = 2
    memory          = "8Gi"
  }
}
