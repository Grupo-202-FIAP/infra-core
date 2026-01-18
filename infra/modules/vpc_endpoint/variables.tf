variable "vpc_id" {
  type        = string
  description = "ID da VPC"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR da VPC para liberar HTTPS no SG"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "IDs das subnets privadas para os endpoints"
}

variable "region" {
  type        = string
  description = "Região AWS"
  default     = "us-east-1"
}

variable "tags" {
  type        = map(string)
  description = "Tags aplicadas aos recursos do módulo"
  default     = {}
}

variable "enable_private_dns_vpce" {
  type        = bool
  description = "Enable private DNS for VPC endpoints"
  default     = true
}

