variable "subnet_name" {
  type        = string
  description = "Prefixo para nome das subnets"
}

variable "vpc_id" {
  type        = string
  description = "ID da VPC"
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

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags aplicadas às subnets"
}