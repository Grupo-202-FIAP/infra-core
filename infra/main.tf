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

module "route_table_private" {
  source           = "./modules/route_table_private"
  route_table_name = "private-route-table"
  vpc_id           = module.vpc.vpc_id
  subnet_ids       = module.private_subnet.private_subnet_ids
  nat_gateway_id   = module.nat_gateway.nat_gateway_id
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

module "security_group_bastion" {
  source           = "./modules/security_group/bastion_sg"
  sg_bastion_name  = var.sg_bastion_name
  vpc_id           = module.vpc.vpc_id
  allowed_ssh_cidr = var.allowed_ssh_cidr
  tags             = var.tags
}

module "security_group_lambda" {
  source         = "./modules/security_group/lambda_sg"
  sg_lambda_name = var.sg_lambda_name
  vpc_id         = module.vpc.vpc_id
  tags           = var.tags
}

module "security_group_postgres" {
  source           = "./modules/security_group/private_sg"
  sg_postgres_name = var.sg_postgres_name
  vpc_id           = module.vpc.vpc_id
  api_sg_id        = module.security_group_api.security_group_id
  bastion_sg_id    = module.security_group_bastion.bastion_sg_id
  lambda_sg_id     = module.security_group_lambda.lambda_sg_id
  tags             = var.tags
}

# 🔹 EC2 Bastion Instance
module "ec2_bastion" {
  source                  = "./modules/ec2_bastion"
  bastion_instance_name   = var.bastion_instance_name
  instance_type           = var.bastion_instance_type
  public_subnet_id        = module.public_subnet.public_subnet_ids[0]
  bastion_sg_id           = module.security_group_bastion.bastion_sg_id
  key_pair_name           = var.key_pair_name
  tags                    = var.tags
}

#🔹 DB Subnet Group para RDS
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = var.subnet_group_name
  subnet_ids = module.private_subnet.private_subnet_ids
  tags = merge(
    { Name = var.subnet_group_name },
    var.tags
  )
}

# 🔹 ACL
module "acl" {
  source    = "./modules/acl"
  acl_name  = var.acl_name
  vpc_id    = module.vpc.vpc_id
  subnet_id = module.public_subnet.public_subnet_ids[0]
  tags      = var.tags
}

module "vpc_endpoint" {
  source             = "./modules/vpc_endpoint"
  vpc_id             = module.vpc.vpc_id
  vpc_cidr           = var.cidr_block
  private_subnet_ids = module.private_subnet.private_subnet_ids
  region             = var.region
  tags               = var.tags
}
