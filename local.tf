locals {
  managed_node_group_name          = "${var.cluster_name}-nodegroup"
  managed_node_name                = "${var.cluster_name}-node"
  managed_node_group_iam_role_name = "${var.cluster_name}-managed-nodegroup-role"
  launch_template_name             = "${var.cluster_name}-launch-template"
}