#########################################
# VPC / NETWORK MODULE
#########################################

module "network" {
  source      = "./modules/network"
  project     = var.project
  component   = var.component
  environment = var.environment
  region      = var.region
  vpc_cidr    = var.vpc_cidr
  az_count    = var.az_count
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  enable_nat_per_az    = var.enable_nat_per_az
  access_cidr      = var.access_cidr
  tags                 = var.tags
}


#########################################
# ECR REPOSITORIES
#########################################

module "ecr_frontend" {
  source = "./modules/ecr"
  name   = "frontend-repo"
}

module "ecr_backend" {
  source = "./modules/ecr"
  name   = "backend-repo"
}

module "ecr_database" {
  source = "./modules/ecr"
  name   = "database-repo"
}


#########################################
# EKS CLUSTER
#########################################

module "eks" {
  source = "./modules/eks"

  project     = var.project
  environment = var.environment

  eks_cluster_version = var.eks_cluster_version

  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids
  public_subnet_ids  = module.network.public_subnet_ids

  # MUST MATCH MODULE VARIABLES EXACTLY
  node_instance_type      = var.eks_node_instance_type
  node_group_desired_size = var.eks_node_desired_size
  node_group_min_size     = var.eks_node_min_size
  node_group_max_size     = var.eks_node_max_size

  disk_size = var.eks_disk_size

  aurora_db_sg_id = null

  tags = var.tags

  depends_on = [module.network]
}


#########################################
# AURORA SERVERLESS v2
#########################################

module "database" {
  source = "./modules/database"

  project            = var.project
  environment        = var.environment
  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids

  database_name   = var.aurora_database_name
  master_username = var.aurora_master_username
  master_password = var.aurora_master_password
  engine_version  = var.aurora_engine_version

  min_capacity = var.aurora_min_capacity
  max_capacity = var.aurora_max_capacity

  allowed_security_group_ids = [module.eks.cluster_security_group_id]

  tags = var.tags

  depends_on = [module.network, module.eks]
}


