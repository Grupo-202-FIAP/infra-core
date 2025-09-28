variable "vpc_name" {
  type        = string
  description = "Nome da VPC"
}

variable "cidr_block" {
  type        = string
  description = "CIDR da VPC"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags aplicadas à VPC"
}