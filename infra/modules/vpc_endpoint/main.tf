resource "aws_security_group" "vpc_endpoints" {
  name        = "vpc-endpoints-sg"
  description = "Security group for VPC Interface Endpoints"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({ Name = "vpc-endpoints-sg" }, var.tags)
}

resource "aws_vpc_endpoint" "sqs" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.sqs"
  vpc_endpoint_type = "Interface"

  subnet_ids         = var.private_subnet_ids
  security_group_ids = [aws_security_group.vpc_endpoints.id]

  private_dns_enabled = var.enable_private_dns_vpce

  tags = merge({ Name = "vpce-sqs" }, var.tags)
}

resource "aws_vpc_endpoint" "sts" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.sts"
  vpc_endpoint_type = "Interface"

  subnet_ids         = var.private_subnet_ids
  security_group_ids = [aws_security_group.vpc_endpoints.id]

  private_dns_enabled = var.enable_private_dns_vpce

  tags = merge({ Name = "vpce-sts" }, var.tags)
}

# 🔹 VPC Endpoints para serviços AWS
# resource "aws_vpc_endpoint" "cognito_idp" {
#   vpc_id              = var.vpc_id
#   service_name        = "com.amazonaws.${var.region}.cognito-idp"
#   vpc_endpoint_type   = "Interface"
#   subnet_ids          = var.private_subnet_ids
#   security_group_ids  = [aws_security_group.vpc_endpoints.id]
#   private_dns_enabled = var.enable_private_dns_vpce

#   tags = merge({ Name = "vpce-cognito-idp" }, var.tags)
# }

resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = [aws_security_group.vpc_endpoints.id]
  private_dns_enabled = var.enable_private_dns_vpce

  tags = merge({ Name = "vpce-ssm" }, var.tags)
}

resource "aws_vpc_endpoint" "ec2" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ec2"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = [aws_security_group.vpc_endpoints.id]
  private_dns_enabled = var.enable_private_dns_vpce

  tags = merge({ Name = "vpce-ec2" }, var.tags)
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = [aws_security_group.vpc_endpoints.id]
  private_dns_enabled = var.enable_private_dns_vpce

  tags = merge({ Name = "vpce-ec2-messages" }, var.tags)
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = [aws_security_group.vpc_endpoints.id]
  private_dns_enabled = var.enable_private_dns_vpce

  tags = merge({ Name = "vpce-ssm-messages" }, var.tags)
}

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = [aws_security_group.vpc_endpoints.id]
  private_dns_enabled = var.enable_private_dns_vpce

  tags = merge({ Name = "vpce-ecr-api" }, var.tags)
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = [aws_security_group.vpc_endpoints.id]
  private_dns_enabled = var.enable_private_dns_vpce

  tags = merge({ Name = "vpce-ecr-dkr" }, var.tags)
}

 

