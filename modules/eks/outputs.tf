# ==================== OUTPUTS ====================

output "cluster_name" {
  value = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "cluster_ca_certificate" {
  value     = aws_eks_cluster.main.certificate_authority[0].data
  sensitive = true
}

output "node_group_id" {
  value = aws_eks_node_group.main.id
}

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.cluster.arn
}

# IMPORTANT: EKS automatically creates the cluster SG
output "cluster_security_group_id" {
  description = "Cluster security group created by EKS"
  value       = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}

# Single node group → output the name
output "node_group_name" {
  description = "EKS node group name"
  value       = aws_eks_node_group.main.node_group_name
}