output "configure_kubectl" {
  description = "Configure kubectl: make sure you're logged in with the correct AWS profile and run the following command to update your kubeconfig"
  value       = <<-EOT
    export KUBECONFIG="/tmp/${module.eks.cluster_name}"
    aws eks --region ${var.region} update-kubeconfig --name ${module.eks.cluster_name}
  EOT
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}
