variable "project" { type = string }
variable "environment" { type = string }

variable "vpc_id" { type = string }
variable "private_subnet_ids" { type = list(string) }

variable "database_name" {
  type        = string
  description = "Aurora DB name"
}

variable "master_username" {
  type        = string
}

variable "master_password" {
  type        = string
  sensitive   = true
}

variable "engine_version" {
  type        = string
}

variable "min_capacity" {
  type        = number
}

variable "max_capacity" {
  type        = number
}

variable "allowed_security_group_ids" {
  type = list(string)
}

variable "tags" {
  type = map(string)
}
