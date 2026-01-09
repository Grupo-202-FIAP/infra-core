resource "aws_security_group" "lambda" {
  name        = var.sg_lambda_name
  description = "Security group para Lambda functions (sem ingress, apenas egress)"
  vpc_id      = var.vpc_id

  # No ingress rules - Lambdas are clients only

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Name = var.sg_lambda_name
    },
    var.tags
  )
}
