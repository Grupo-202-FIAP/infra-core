variable "sg_postgres_name" {
  type        = string
  description = "Nome do SG do PostgreSQL"
  default = ""
}

variable "vpc_id" {
  type        = string
  description = "ID da VPC"
}

variable "api_sg_id" {
  type        = string
  description = "ID do SG da API que pode acessar o banco"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags aplicadas ao SG"
}
