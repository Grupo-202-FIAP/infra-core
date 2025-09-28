variable "igw_name" {
  type        = string
  description = "Nome do IGW"
}

variable "vpc_id" {
  type        = string
  description = "ID da VPC"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags aplicadas ao IGW"
}

