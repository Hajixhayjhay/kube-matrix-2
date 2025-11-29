locals {
  name_prefix = "${var.project}-${var.environment}"
}

resource "aws_db_subnet_group" "main" {
  name       = "${local.name_prefix}-subnets"
  subnet_ids = var.private_subnet_ids

  tags = var.tags
}

resource "aws_security_group" "main" {
  name        = "${local.name_prefix}-aurora-sg"
  description = "Aurora access security group"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 3306
    to_port     = 3306
    cidr_blocks = []
    security_groups = var.allowed_security_group_ids
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_rds_cluster" "main" {
  cluster_identifier   = "${local.name_prefix}-aurora"
  engine               = "aurora-mysql"
  engine_version       = var.engine_version

  database_name  = var.database_name
  master_username = var.master_username
  master_password = var.master_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.main.id]

  serverlessv2_scaling_configuration {
    min_capacity = var.min_capacity
    max_capacity = var.max_capacity
  }

  backup_retention_period = 1
  storage_encrypted       = true
  skip_final_snapshot     = true

  tags = var.tags
}

resource "aws_rds_cluster_instance" "main" {
  cluster_identifier  = aws_rds_cluster.main.id
  instance_class      = "db.serverless"
  engine              = "aurora-mysql"
  engine_version      = var.engine_version

  publicly_accessible = false

  tags = var.tags
}

