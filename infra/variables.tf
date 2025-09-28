variable "vpc_name" {
  type        = string
  description = "Nome da VPC"
}

variable "subnet_name" {
  type        = string
  description = "Prefixo para nome das subnets"
}

variable "igw_name" {
  type        = string
  description = "Nome do Internet Gateway"
}

variable "sg_api_name" {
  type        = string
  description = "Nome do Security Group da API"
}

variable "sg_postgres_name" {
  type        = string
  description = "Nome do Security Group do PostgreSQL"
}

variable "acl_name" {
  type        = string
  description = "Nome do Network ACL"
}

variable "cidr_block" {
  type        = string
  description = "CIDR da VPC"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags aplicadas aos recursos"
}

variable "azs" {
  type        = list(string)
  description = "Zonas de disponibilidade"
}

variable "public_subnets" {
  type        = list(string)
  description = "CIDRs das subnets públicas"
}

variable "private_subnets" {
  type        = list(string)
  description = "CIDRs das subnets privadas"
}

variable "route_cidr" {
  type        = string
  default     = "0.0.0.0/0"
  description = "CIDR para rota padrão"
}