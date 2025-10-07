module "vpc" {
  source     = "./modules/vpc"
  vpc_name   = var.vpc_name
  cidr_block = var.cidr_block
  tags       = var.tags
}

module "private_subnet" {
  source            = "./modules/subnet/private_subnet"
  subnet_name       = var.subnet_name
  vpc_id            = module.vpc.vpc_id
  azs               = var.azs
  private_subnets   = var.private_subnets
  subnet_group_name = var.subnet_group_name
  tags              = var.tags
}

module "public_subnet" {
  source         = "./modules/subnet/public_subnet"
  subnet_name    = var.subnet_name
  vpc_id         = module.vpc.vpc_id
  azs            = var.azs
  public_subnets = var.public_subnets
  tags           = var.tags
}

module "internet_gateway" {
  source   = "./modules/internet_gateway"
  igw_name = var.igw_name
  vpc_id   = module.vpc.vpc_id
  tags     = var.tags
}

module "nat_gateway" {
  source           = "./modules/nat_gateway"
  nat_name         = var.nat_name
  public_subnet_id = module.public_subnet.public_subnet_ids[0]
  tags             = var.tags
}

module "route_table" {
  source           = "./modules/route_table"
  route_table_name = var.route_table_name
  vpc_id           = module.vpc.vpc_id
  subnet_ids       = module.public_subnet.public_subnet_ids
  gateway_id       = module.internet_gateway.igw_id
  route_cidr       = var.route_cidr
  tags             = var.tags
}

module "security_group_api" {
  source      = "./modules/security_group/public_sg"
  sg_api_name = var.sg_api_name
  vpc_id      = module.vpc.vpc_id
  tags        = var.tags
}

module "security_group_postgres" {
  source           = "./modules/security_group/private_sg"
  sg_postgres_name = var.sg_postgres_name
  vpc_id           = module.vpc.vpc_id
  api_sg_id        = module.security_group_api.security_group_id
  tags             = var.tags
}

# 🔹 ACL
module "acl" {
  source    = "./modules/acl"
  acl_name  = var.acl_name
  vpc_id    = module.vpc.vpc_id
  subnet_id = module.public_subnet.public_subnet_ids[0]
  tags      = var.tags
}

module "api_gateway" {
  source      = "./modules/api_gateway"
  name        = var.api_gw_name
  description = var.api_gw_description
  root_path   = var.api_gw_root_path
  stage_name  = var.api_stage_name
}

module "rds_instance" {
  source               = "./modules/rds"
  rds_identifier_name  = var.rds_identifier_name
  rds_sg_ids           = [module.security_group_postgres.postgres_sg_id]
  db_subnet_group_name = module.private_subnet.subnet_group_name
  private_subnet_ids   = module.private_subnet.private_subnet_ids

  rds_username_secret_name = var.rds_username_ssm_path
  rds_password_secret_name = var.rds_password_ssm_path
  rds_url_secret_name = var.rds_url_ssm_path

  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  engine            = var.engine
  engine_version    = var.engine_version
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = var.bucket_name
}
