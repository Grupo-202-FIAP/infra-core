# VPC
vpc_name   = "infra-vpc"
cidr_block = "10.0.0.0/16"

# Subnets
subnet_name     = "infra-subnet"
azs             = ["us-east-1a", "us-east-1b"]
public_subnets  = "10.0.1.0/24"
private_subnets = ["10.0.6.0/24", "10.0.10.0/24"]
subnet_group_name = "infra-subnet-private"

# NAT Gateway
nat_name = "infra-nat-gateway"

# Internet Gateway
igw_name = "infra-igw"

# Route Table
route_table_name = "infra-public-route-table"
route_cidr = "0.0.0.0/0"

# Security Groups
sg_api_name      = "infra-sg-api"
sg_postgres_name = "infra-sg-postgres"

# ACL
acl_name = "infra-acl"

# Tags
tags = {
  Owner = "fast-food-fiap"
}

# RDS
rds_identifier_name  = "db-fastfood"
rds_username_ssm_path = "/fastfood/rds/username"
rds_password_ssm_path = "/fastfood/rds/password"
instance_class = ""
allocated_storage = 50
engine = "postgres"
engine_version = "15"

# Gateway
api_gw_name        = "crud-api"
api_gw_description = "CRUD API Gateway"
api_gw_root_path   = "items"
api_stage_name  = "dev"
