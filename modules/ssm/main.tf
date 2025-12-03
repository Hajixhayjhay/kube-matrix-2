locals {
  name_prefix = "${var.project}-${var.environment}"
}

resource "aws_ssm_parameter" "db_username" {
  name      = "/${local.name_prefix}/db/username"
  type      = "SecureString"
  value     = var.db_username
  overwrite = true
}

resource "aws_ssm_parameter" "db_password" {
  name      = "/${local.name_prefix}/db/password"
  type      = "SecureString"
  value     = var.db_password
  overwrite = true
}

resource "aws_ssm_parameter" "db_endpoint" {
  name      = "/${local.name_prefix}/db/endpoint"
  type      = "String"
  value     = var.db_endpoint
  overwrite = true
}

resource "aws_ssm_parameter" "db_name" {
  name      = "/${local.name_prefix}/db/name"
  type      = "String"
  value     = var.db_name
  overwrite = true
}
