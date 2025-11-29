output "cluster_id" {
  description = "Aurora Cluster ID"
  value       = aws_rds_cluster.main.id
}

output "cluster_endpoint" {
  description = "Writer endpoint of Aurora cluster"
  value       = aws_rds_cluster.main.endpoint
}

output "reader_endpoint" {
  description = "Reader endpoint of Aurora cluster"
  value       = aws_rds_cluster.main.reader_endpoint
}

output "security_group_id" {
  description = "Security group attached to the Aurora cluster"
  value       = aws_security_group.main.id
}
