variable "vpc_id" {
  type        = string
  description = "ID da VPC"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Lista de IDs das subnets privadas"
}

variable "nat_gateway_id" {
  type        = string
  description = "ID do NAT Gateway"
}

variable "route_cidr" {
  type        = string
  default     = "0.0.0.0/0"
  description = "CIDR para rota padrão"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags aplicadas à route table"
}

variable "route_table_name" {
  description = "Nome da Tabela de Rotas Privada"
  type        = string
}