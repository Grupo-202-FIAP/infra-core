
variable "bucket_name" {
  description = "Nome do bucket S3 para armazenar o state"
  type        = string
  default     = "nextime-food-state-bucket"
}

variable "enable_s3" {
  description = "Habilita criação do bucket S3 (usar false para desativar deploy S3)"
  type        = bool
  default     = false
}

variable "environment" {
  description = "Ambiente de deploy"
  type        = string
  default     = "dev"
}



 