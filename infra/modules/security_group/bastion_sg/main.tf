resource "aws_security_group" "bastion" {
  name        = var.sg_bastion_name
  description = "Security group para Bastion Host (SSH acesso)"
  vpc_id      = var.vpc_id

  # ingress {
  #   description = "SSH access from allowed CIDR"
  #   from_port   = 22
  #   to_port     = 22
  #   protocol    = "tcp"
  #   cidr_blocks = [var.allowed_ssh_cidr]
  # }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Name = var.sg_bastion_name
    },
    var.tags
  )
}
