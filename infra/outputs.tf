output "vpc_id" {
  description = "ID da VPC criada"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Lista de IDs das subnets públicas"
  value       = module.public_subnet.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Lista de IDs das subnets privadas"
  value       = module.private_subnet.private_subnet_ids
}

output "internet_gateway_id" {
  description = "ID do Internet Gateway"
  value       = module.internet_gateway.igw_id
}

output "route_table_id" {
  description = "ID da Route Table"
  value       = module.route_table.route_table_id
}

output "security_group_api_id" {
  description = "ID do Security Group da API"
  value       = module.security_group_api.security_group_id
}

output "sg_bastion_id" {
  description = "ID do Security Group do Bastion Host"
  value       = module.security_group_bastion.bastion_sg_id
}

output "sg_lambda_id" {
  description = "ID do Security Group das Lambdas"
  value       = module.security_group_lambda.lambda_sg_id
}

output "sg_rds_id" {
  description = "ID do Security Group do RDS (PostgreSQL)"
  value       = module.security_group_postgres.postgres_sg_id
}

output "security_group_postgres_id" {
  description = "ID do Security Group do PostgreSQL (compatibilidade)"
  value       = module.security_group_postgres.postgres_sg_id
}

output "db_subnet_group_name" {
  description = "Nome do DB Subnet Group para RDS"
  value       = aws_db_subnet_group.rds_subnet_group.name
}
