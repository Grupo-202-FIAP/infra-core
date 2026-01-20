output "vpc_endpoints_sg_id" {
  value       = aws_security_group.vpc_endpoints.id
  description = "ID do Security Group usado pelos VPC Interface Endpoints"
}

output "sqs_vpc_endpoint_id" {
  value       = aws_vpc_endpoint.sqs.id
  description = "ID do VPC Endpoint para SQS"
}

output "sts_vpc_endpoint_id" {
  value       = aws_vpc_endpoint.sts.id
  description = "ID do VPC Endpoint para STS"
}

