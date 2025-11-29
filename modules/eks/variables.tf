variable "project" {}
variable "environment" {}
variable "eks_cluster_version" {}

variable "vpc_id" {}
variable "private_subnet_ids" {
  type = list(string)
}
variable "public_subnet_ids" {
  type = list(string)
}

variable "node_instance_type" {
  type = string
}

variable "node_group_desired_size" {
  type = number
}

variable "node_group_min_size" {
  type = number
}

variable "node_group_max_size" {
  type = number
}

variable "disk_size" {
  type = number
}

variable "aurora_db_sg_id" {
  type    = string
  default = null
}

variable "tags" {
  type = map(string)
  default = {}
}
