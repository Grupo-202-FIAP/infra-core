resource "aws_security_group" "postgres" {
  name        = var.sg_postgres_name
  description = "SG para PostgreSQL privado"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Acesso da API"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.api_sg_id]
  }

  egress {
    description = "Saída liberada"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}