variable "project" {
  type        = string
  description = "short project code (ex: km)"
}

variable "component" {
  type        = string
  description = "component name (vpc)"
  default     = "vpc"
}

variable "environment" {
  type        = string
  description = "env: dev|stage|prod"
  default     = "dev"
}

variable "region" {
  type        = string
  description = "AWS region (eg: us-east-1)"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR for VPC"
  default     = "10.10.0.0/16"
}

variable "az_count" {
  type        = number
  description = "Number of AZs to use (2 recommended)"
  default     = 2
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for public subnets; if empty they will be auto-generated"
  default     = []
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for private subnets; if empty they will be auto-generated"
  default     = []
}

variable "enable_nat_per_az" {
  type        = bool
  description = "Create a NAT Gateway per AZ (HA) or single NAT"
  default     = false
}

variable "access_cidr" {
  type        = string
  description = "Optional: developer/corporate CIDR allowed for dev access"
  default     = ""
}

variable "tags" {
  type        = map(string)
  description = "Common tags"
  default     = {}
}
