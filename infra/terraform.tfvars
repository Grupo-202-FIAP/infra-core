# VPC
vpc_name   = "infra-vpc"
cidr_block = "10.0.0.0/16"
region = "us-east-1"

# Subnets
subnet_name     = "infra-subnet"
azs             = ["us-east-1a", "us-east-1b"]
public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets = ["10.0.6.0/24", "10.0.10.0/24"]
subnet_group_name = "infra-subnet-private"

# NAT Gateway
nat_name = "infra-nat-gateway"

# Internet Gateway
igw_name = "infra-igw"

# Route Table
route_table_public_name = "infra-public-route-table"
route_table_private_name = "infra-private-route-table"
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
instance_class = "db.t3.micro"
allocated_storage = 50
engine = "postgres"
engine_version = "15"

# S3
bucket_name = "terraform-state-bucket-nextime"

# =====================
# API Gateway
# =====================
api_gw_name         = "nexTimeFoodAPI"
api_gw_description  = "Gateway HTTP central para nexTimeFood (EKS + Lambdas)"
api_gw_stage_name   = "dev"

# Backend EKS
eks_alb_dns_name    = "http://internal-nexfood-alb-123456.us-east-1.elb.amazonaws.com"

# =====================
# SQS
# =====================
sqs_queue_name                 = "fastfood-queue"
sqs_delay_seconds              = 0
sqs_max_message_size           = 262144
sqs_message_retention_seconds  = 345600
sqs_receive_wait_time_seconds  = 0
sqs_visibility_timeout_seconds = 30
sqs_max_receive_count          = 3
sqs_enable_queue_policy        = false