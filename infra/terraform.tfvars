# VPC
vpc_name    = "infra-vpc"
cidr_block  = "10.0.0.0/16"

# Subnets
subnet_name     = "infra-subnet"
azs             = ["us-east-1a", "us-east-1b"]
public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]

# Internet Gateway
igw_name = "infra-igw"

# Route Table
route_cidr = "0.0.0.0/0"

# Security Groups
sg_api_name      = "infra-sg-api"
sg_postgres_name = "infra-sg-postgres"

# ACL
acl_name = "infra-acl"

# Tags
tags = {
  Owner       = "fast-food-fiap"
}