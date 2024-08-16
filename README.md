# EKS Based GitHub Self Hosted  Runner

## Overview

This repository can be used to provision a  EKS cluster that can host different types of GitHub self-hosted Runner.

As per default configuration, tt supports the  **3 different types** of runners with the following configuration

| Runner-Name | minRunners | maxRunners |  instance_type | cpu | memory |
|----------------|-----------------|------------|------------|-----------------|----------------|
| eks-small     |  1 | 4 | t2.large |  1 | 2Gi |
| eks-medium    |  1 | 4 | t2.xlarge" |  1 | 4Gi |
| eks-large    |  1 | 4 | t2.2xlarge |  2 | 8Gi |

** all the above parameters can be adjusted inside terraform.tfvars file based on self-hosted runners requirement. For more information, refer to the section `Input parameters`

## Pre-Requisite

Create a PAT token in Github and provide access repo and admin level.
Add that token in the AWS secret manager.
provide `pat_secret_name` = `<NAME>` in terraform.tfvars file.

in `githubConfigUrl` replace with your github repo URL where the runner will be registered.

## Input parameters

input parameters can be provided in the `terraform.tfvars` file.

**A sample terraform.tfvars file will looks like as follows**

```

region                  = "us-west-1"                         ## AWS Region where the EKS cluster will be deployed
cluster_name            = "my-eks-cluster"                    ## EKS cluster name to be created
kubernetes_version      = "1.30"                              ## EKS version
cluster_name            = "my-eks-cluster"
vpc_cidr                = "10.0.0.0/16"                       ## VPC CIDR to be created
private_subnet_id       = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]         # List of Private Subnet CIDRs
public_subnet_id        = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]   # List of Public Subnet CIDRs

pat_secret_name = "mypat"                                      ## Secret Name that is created as part of the Pre-Req

runner_set_parameters = {
  eks-small = {
    githubConfigUrl = "https://github.com/sandipgangapadhyay/githubactiontest"        # Github Repo URL where the self hosted runners will be registered
    minRunners      = 1                                                               # Minimum number of runner always available
    maxRunners      = 4                                                               # Maximum number of runner can be the scaled in to
    node-pool-name  = "eks-small"                                                     # Runner name that can be referenced in the github workflow file
    instance_type   = "t2.large"                                                      # Underlying EC2 instance type for this self hosted runner
    cpu             = 1                                                             # CPU request for github Self hosted runner POD
    memory          = "2Gi"                                                           # Memory request for github Self hosted runner POD
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

```

## How to deploy the solution

This solution is implemented with GitHub Action. To deploy the solution, 

1. clone the Repo
2. update the terraform.tfvars file based on the requirement
3. Run `terraform init`
4. Run `terraform plan`
5. Run `terraform apply`

## Verification

WIP

## How to use self-hosted GitHub Runner

Now that you have deployed self hosted github runner backed by EKS, the team can simply create their workflow and provide one of the runner types (`eks-small`/`eks-medium`/`eks-large`) in `runs-on` section. An example workflow might look like this - 

```
name: test gha runner
on:
  workflow_dispatch:

permissions:
  id-token: write   
  contents: read  

jobs:
       
  job-eks-small:
    runs-on: eks-small
    steps:
      - name: "Print"
        run: |
          echo "Hello World - Running on small runner"   
          sleep 60
  job-eks-medium:
    runs-on: eks-medium
    steps:
      - name: "Print"
        run: |
          echo "Hello World - Runner on EKS  medium runner "          
          sleep 60
  job-eks-large:
    runs-on: eks-large
    steps:
      - name: "Print"
        run: |
          echo "Hello World - Running on EKS large runner"          
          sleep 30          
```


## Security

See [CONTRIBUTING](CONTRIBUTING.md#security-issue-notifications) for more information.

## License

This library is licensed under the MIT-0 License. See the LICENSE file.

