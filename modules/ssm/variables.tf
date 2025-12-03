# Project / Environment
variable "project" {
  type = string
}

variable "environment" {
  type = string
}

# Database SSM parameters
variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
  sensitive = true
}

variable "db_endpoint" {
  type = string
}

variable "db_name" {
  type = string
}
