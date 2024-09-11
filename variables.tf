variable "vpc_id" {
  description = "VPC CIDR"
  type        = string
  default     = "vpc-0b5640bdd78c4f096"
}
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-1"
}
variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.30"
}

variable "cluster_name" {
  description = "EKS Cluster Name"
  type        = string
  default     = ""
}
variable "ebs_device_name" {
  type    = string
  default = "/dev/xvda"
}
variable "ebs_volume_size" {
  type    = number
  default = 20
}
variable "ebs_delete_on_termination" {
  type    = bool
  default = true
}
variable "ebs_volume_type" {
  type    = string
  default = "gp3"
}
variable "ebs_volume_iops" {
  type    = number
  default = 3000
}
variable "tags" {
  type = any
  default = {
    env = "dev"
  }
}

variable "launch_template_description" {
  type    = string
  default = "EKS cluster launch template"
}

variable "desired_size" {
  type    = number
  default = 2
}
variable "instance_type" {
  type    = list(any)
  default = ["t2.medium"]
}

variable "max_unavailable" {
  type    = number
  default = 1
}
variable "max_size" {
  type    = number
  default = 3
}

variable "min_size" {
  type    = number
  default = 2
}
variable "pat_secret_name" {
  type = string
}
variable "vpc_name" {
  type = string
}

variable "runner_set_parameters" {
  type    = map(any)
  default = {}
}
variable "private_subnet_id" {
  description = "Subnet IDs for EKS"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnet_id" {
  description = "Subnet IDs for EKS"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}