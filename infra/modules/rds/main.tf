resource "aws_db_subnet_group" "infra_private" {
  name        = var.db_subnet_group_name
  description = "Subnets privadas para o RDS"
  subnet_ids  = var.private_subnet_ids

  tags = {
    Name = var.db_subnet_group_name
  }
}

resource "aws_db_instance" "rds" {
  identifier          = var.rds_identifier_name
  allocated_storage   = var.allocated_storage
  instance_class      = var.instance_class
  publicly_accessible = false

  engine         = var.engine
  engine_version = var.engine_version
  username       = aws_ssm_parameter.rds_username.value
  password       = aws_ssm_parameter.rds_password.value

  vpc_security_group_ids = var.rds_sg_ids
  db_subnet_group_name   = aws_db_subnet_group.infra_private.name

  skip_final_snapshot = true

  depends_on = [aws_db_subnet_group.infra_private]
}

resource "aws_ssm_parameter" "rds_username" {
  name        = var.rds_username_secret_name
  description = "RDS Master Username para o ambiente Dev Fastfood"
  type        = "String"
  value       = "postgres"
  overwrite   = true
}

resource "aws_ssm_parameter" "rds_password" {
  name        = var.rds_password_secret_name
  description = "RDS Master Password para o ambiente Dev Fastfood"
  type        = "SecureString"
  value       = random_password.rds_password.result
  overwrite   = true
}

resource "random_password" "rds_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  min_special      = 1
  min_upper        = 1
  min_lower        = 1
  min_numeric      = 1
}

resource "aws_ssm_parameter" "rds_connection_url" {

  name        = var.rds_url_secret_name
  description = "URL de Conexão Completa para o RDS (Formato URI)"
  type        = "SecureString"

  value = "postgres://${aws_ssm_parameter.rds_username.value}:${aws_ssm_parameter.rds_password.value}@${aws_db_instance.rds.address}:${aws_db_instance.rds.port}/${var.rds_identifier_name}"

  overwrite = true
}

