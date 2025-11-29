output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "Public subnet ids"
  value       = [for s in aws_subnet.public : s.id]
}

output "private_subnet_ids" {
  description = "Private subnet ids"
  value       = [for s in aws_subnet.private : s.id]
}

output "public_subnet_cidrs" {
  value = [for s in aws_subnet.public : s.cidr_block]
}

output "private_subnet_cidrs" {
  value = [for s in aws_subnet.private : s.cidr_block]
}

output "nat_gateway_ids" {
  value = aws_nat_gateway.nat[*].id
}

output "security_group_ids" {
  value = {
    bastion   = aws_security_group.bastion_sg.id
    eks_nodes = aws_security_group.eks_nodes_sg.id
    db        = aws_security_group.db_sg.id
  }
}
