output "lambda_sg_id" {
  description = "ID of the lambda security group"
  value       = aws_security_group.lambda.id
}

output "lambda_sg_arn" {
  description = "ARN of the lambda security group"
  value       = aws_security_group.lambda.arn
}
