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

module "security_group_postgres" {
  source           = "./modules/security_group/private_sg"
  sg_postgres_name = var.sg_postgres_name
  vpc_id           = module.vpc.vpc_id
  api_sg_id        = module.security_group_api.security_group_id
  tags             = var.tags
}

# VPC Endpoint for Cognito (Interface) + SG to allow Lambdas to reach Cognito via endpoint
resource "aws_security_group" "vpc_endpoint_cognito_sg" {
  name        = "vpc-endpoint-cognito"
  description = "Security group for Cognito VPC Endpoint"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "Allow Lambdas (private SG) to connect to endpoint"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [module.security_group_postgres.postgres_sg_id]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_vpc_endpoint" "cognito_idp" {
  vpc_id             = module.vpc.vpc_id
  service_name       = "com.amazonaws.${var.region}.cognito-idp"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = module.private_subnet.private_subnet_ids
  security_group_ids = [aws_security_group.vpc_endpoint_cognito_sg.id]
  private_dns_enabled = false

  tags = merge({ Name = "vpce-cognito-idp" }, var.tags)
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
  source              = "./modules/vpc_endpoint"
  vpc_id              = module.vpc.vpc_id
  vpc_cidr            = var.cidr_block
  private_subnet_ids  = module.private_subnet.private_subnet_ids
  region              = var.region
  tags                = var.tags
}
