# variable "bucket_name" {
#   description = "Nome do bucket S3 para armazenar o state"
#   type        = string
#   default     = "nextime-food-state-bucket"
# }

variable "environment" {
  description = "Ambiente de deploy"
  type        = string
  default     = "dev"
}
