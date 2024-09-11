terraform {
  backend "s3" {
    bucket         = "<UPDATE_HERE>"                       # S3 Bucket name from the CFN stack output
    key            = "eks_gha_karpenter/terraform.tfstate" # Terraform State file name
    region         = "<UPDATE_HERE>"                       # AWS Region name where CFN stack resources exist
    encrypt        = true
    dynamodb_table = "<UPDATE_HERE>" # DynamoDB table name from the CFN stack output
  }
}