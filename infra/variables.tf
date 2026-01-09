variable "vpc_name" {
  type        = string
  description = "Nome da VPC"
  default     = ""
}

variable "subnet_name" {
  type        = string
  description = "Prefixo para nome das subnets"
}

variable "nat_name" {
  type        = string
  description = "Nome do Nat Gateway"
}

variable "subnet_group_name" {
  type        = string
  description = "Nome para o grupo das subnets"
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

variable "sg_bastion_name" {
  type        = string
  description = "Nome do Security Group do Bastion Host"
  default     = "infra-sg-bastion"
}

variable "sg_lambda_name" {
  type        = string
  description = "Nome do Security Group das Lambdas"
  default     = "infra-sg-lambda"
}

variable "allowed_ssh_cidr" {
  type        = string
  description = "CIDR block allowed to SSH to bastion"
  default     = "0.0.0.0/0"
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
  description = "Zona de disponibilidade"
}

variable "public_subnets" {
  type        = list(string)
  description = "CIDR das subnets públicas"
}

variable "private_subnets" {
  type        = list(string)
  description = "CIDR da subnet privada"
}

variable "route_cidr" {
  type        = string
  default     = "0.0.0.0/0"
  description = "CIDR para rota padrão"
}

variable "route_table_name" {
  description = "Nome do recurso para a Tabela de Rotas Pública (ex: infra-public-rt)."
  type        = string
}

variable "bucket_name" {
  description = "Nome do bucket"
  type        = string
}

variable "region" {
  description = "Região da AWS"
  type = string
}