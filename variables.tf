#########################################
# Global Settings
#########################################

variable "project" {
  description = "Project name"
  type        = string
  default     = "km"
}

variable "environment" {
  description = "Environment (dev/stage/prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = can(regex("^(dev|stage|prod)$", var.environment))
    error_message = "Environment must be dev, stage, or prod"
  }
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "tags" {
  description = "Additional resource tags"
  type        = map(string)
  default     = { Owner = "platform-team", CostCenter = "CC-12345" }
}


#########################################
# VPC Settings
#########################################
variable "component" { default = "vpc" }

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.10.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.10.1.0/24", "10.10.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.10.101.0/24", "10.10.102.0/24"]
}

variable "az_count" {
  description = "Number of AZs (used if AZ list not provided)"
  type        = number
  default     = 2
}

variable "azs" {
  description = "Specific Availability Zones to use"
  type        = list(string)
  default     = []
}

variable "enable_nat_per_az" {
  description = "Enable 1 NAT gateway per AZ"
  type        = bool
  default     = false
}

variable "access_cidr" {
  description = "Allowed CIDR for SSH or administrative access"
  type        = string
  default     = "34.229.141.205/32"
}


#########################################
# EKS Settings
#########################################

variable "eks_cluster_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.29"
}

variable "eks_node_instance_types" {
  description = "Node instance types"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "eks_node_instance_type" {
  type = string
}

variable "eks_node_desired_size" {
  type = number
}

variable "eks_node_min_size" {
  type = number
}

variable "eks_node_max_size" {
  type = number
}

variable "eks_disk_size" {
  type = number
}


#########################################
# Aurora Serverless v2 Settings
#########################################

variable "aurora_database_name" {
  description = "Aurora MySQL DB name"
  type        = string
  default     = "kubeplatform"
}

variable "aurora_master_username" {
  description = "Aurora master username"
  type        = string
  default     = "admin"
  sensitive   = true
}

variable "aurora_master_password" {
  type      = string
  sensitive = true
}

variable "aurora_engine_version" {
  description = "Aurora MySQL engine version"
  type        = string
  default     = "8.0.mysql_aurora.3.05.2"
}

variable "aurora_min_capacity" {
  description = "Serverless v2 minimum ACUs"
  type        = number
  default     = 0.5
}

variable "aurora_max_capacity" {
  description = "Serverless v2 maximum ACUs"
  type        = number
  default     = 4
}
