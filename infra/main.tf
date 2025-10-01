module "vpc" {
  source     = "./modules/vpc"
  vpc_name   = var.vpc_name
  cidr_block = var.cidr_block
  tags       = var.tags
}

module "subnet" {
  source          = "./modules/subnet"
  subnet_name     = var.subnet_name
  vpc_id          = module.vpc.vpc_id
  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  tags            = var.tags
}

module "internet_gateway" {
  source   = "./modules/internet_gateway"
  igw_name = var.igw_name
  vpc_id   = module.vpc.vpc_id
  tags     = var.tags
}

module "nat_gateway" {
  source           = "./modules/nat_gateway"
  nat_name         = "nat-gateway"
  public_subnet_id = module.subnet.public_subnet_ids[0]
  tags             = var.tags
}

module "route_table" {
  source     = "./modules/route_table"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.subnet.public_subnet_ids
  gateway_id = module.internet_gateway.igw_id
  route_cidr = "0.0.0.0/0"
  tags       = var.tags
}

# 🔹 Security Groups
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
  subnet_id = module.subnet.public_subnet_ids[0]
  tags      = var.tags
}

module "api_gateway" {
  source      = "./modules/api_gateway"
  name        = "crud-api"
  description = "CRUD API Gateway"
  root_path   = "items"
  stage_name  = "dev"
}