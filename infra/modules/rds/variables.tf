variable "rds_identifier_name" {
  description = "Nome do banco de dados inicial a ser criado no RDS."
  type        = string
  default     = " "
}
#
variable "rds_username_secret_name" {
  description = "O ARN ou nome do segredo no AWS Secrets Manager que contém o nome de usuário do DB."
  type        = string
}

variable "rds_password_secret_name" {
  description = "O ARN ou nome do segredo no AWS Secrets Manager que contém a senha do DB."
  type        = string
  sensitive   = true
}

variable "rds_sg_ids" {
  description = "Lista de IDs de Security Groups a serem anexados ao RDS."
  type        = list(string)
}

variable "db_subnet_group_name" {
  description = "O nome do DB Subnet Group para posicionar o RDS."
  type        = string
}

variable "allocated_storage" {
  description = "Armazenamento alocado em GB para a instância RDS."
  type        = number
}

variable "instance_class" {
  description = "Classe da instância RDS (ex: db.t3.micro para Free Tier)."
  type        = string
}

variable "engine" {
  description = "Motor do banco de dados (ex: postgres, mysql)."
  type        = string
}

variable "engine_version" {
  description = "Versão do motor do banco de dados (ex: 15.5)."
  type        = string
}