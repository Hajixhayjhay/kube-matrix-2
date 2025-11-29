#########################################
# VPC Outputs
#########################################

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.network.private_subnet_ids
}

output "public_subnet_cidrs" {
  description = "CIDRs for public subnets"
  value       = module.network.public_subnet_cidrs
}

output "private_subnet_cidrs" {
  description = "CIDRs for private subnets"
  value       = module.network.private_subnet_cidrs
}

output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = module.network.nat_gateway_ids
}

output "security_group_ids" {
  description = "Security groups created by the network module"
  value       = module.network.security_group_ids
}

output "aws_region" {
  description = "AWS region used"
  value       = var.region
}


#########################################
# ECR Outputs
#########################################

output "ecr_frontend_repository_url" {
  description = "Frontend ECR repository URL"
  value       = module.ecr_frontend.ecr_repository_url
}

output "ecr_frontend_policy_arn" {
  description = "Frontend ECR lifecycle policy ARN"
  value       = module.ecr_frontend.ecr_policy_arn
}

output "ecr_backend_repository_url" {
  description = "Backend ECR repository URL"
  value       = module.ecr_backend.ecr_repository_url
}

output "ecr_backend_policy_arn" {
  description = "Backend ECR lifecycle policy ARN"
  value       = module.ecr_backend.ecr_policy_arn
}

output "ecr_database_repository_url" {
  description = "Database ECR repository URL"
  value       = module.ecr_database.ecr_repository_url
}

output "ecr_database_policy_arn" {
  description = "Database ECR lifecycle policy ARN"
  value       = module.ecr_database.ecr_policy_arn
}


#########################################
# EKS Outputs
#########################################

output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS API Server endpoint"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_ca_certificate" {
  description = "EKS CA certificate for kubectl authentication"
  value       = module.eks.cluster_ca_certificate
  sensitive   = true
}

output "eks_oidc_provider_arn" {
  description = "OIDC provider ARN for IRSA"
  value       = module.eks.oidc_provider_arn
}

output "eks_node_group_name" {
  value = module.eks.node_group_name
}


#########################################
# Aurora Serverless v2 Outputs
#########################################

output "aurora_cluster_endpoint" {
  description = "Aurora cluster endpoint (writer)"
  value       = module.database.cluster_endpoint
}

output "aurora_reader_endpoint" {
  description = "Aurora reader endpoint"
  value       = module.database.reader_endpoint
}

output "aurora_cluster_id" {
  description = "ID of the Aurora cluster"
  value       = module.database.cluster_id
}


#########################################
# Load Balancer / Ingress Outputs
#########################################

# If using AWS Load Balancer Controller / Ingress → ALB DNS
/*output "alb_dns" {
  description = "ALB / Ingress DNS name"
  value       = try(module.alb.ingress_hostname, null)
}

# If using a standalone ALB module
output "external_alb_dns" {
  description = "Standalone ALB DNS name"
  value       = try(module.alb.lb_dns_name, null)
}*/
