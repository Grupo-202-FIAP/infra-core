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
  db_subnet_group_name   = var.db_subnet_group_name

  skip_final_snapshot = true
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

  value     = random_password.rds_password.result
  overwrite = true
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
