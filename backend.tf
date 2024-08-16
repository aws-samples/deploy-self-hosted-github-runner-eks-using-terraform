terraform {
  backend "s3" {
    bucket         = "deploy-self-hosted-gha-eks-using-terraform-1"
    key            = "apg_terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-state-lock-ddb-1"
    encrypt        = true
  }
}