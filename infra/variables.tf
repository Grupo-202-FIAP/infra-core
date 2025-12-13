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

variable "rds_username_ssm_path" {
  description = "Caminho (name) no SSM Parameter Store para o nome de usuário do RDS."
  type        = string
}

variable "rds_password_ssm_path" {
  description = "Caminho (name) no SSM Parameter Store para a senha do RDS."
  type        = string
}

variable "instance_class" {
  description = "Classe da instância RDS (ex: db.t3.micro, db.m6g.large)."
  type        = string
}

variable "allocated_storage" {
  description = "Tamanho inicial do armazenamento alocado para a instância RDS em GB."
  type        = number
}

variable "engine" {
  description = "Engine do banco de dados (ex: postgres, mysql, oracle-se2)."
  type        = string
}

variable "engine_version" {
  description = "Versão principal do Engine do banco de dados (ex: 15, 14.7)."
  type        = string
}

variable "rds_identifier_name" {
  description = "Identificador único da instância RDS (o nome da instância na AWS)."
  type        = string
}

variable "route_table_public_name" {
  description = "Nome do recurso para a Tabela de Rotas Pública (ex: infra-public-rt)."
  type        = string
}

variable "route_table_private_name" {
  description = "Nome do recurso para a Tabela de Rotas Privada (ex: infra-private-rt)."
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

variable "api_gw_name" {
  type        = string
  description = "Nome da API Gateway"
}

variable "api_gw_description" {
  type        = string
  description = "Descrição da API Gateway"
}

variable "api_gw_stage_name" {
  type        = string
  description = "Nome do stage da API Gateway"
}

variable "eks_alb_dns_name" {
  type        = string
  description = "DNS do ALB que faz proxy para o backend no EKS"
}

# SQS
variable "sqs_queue_name" {
  description = "Nome da fila SQS"
  type        = string
}

variable "sqs_delay_seconds" {
  description = "Tempo em segundos que as mensagens ficam atrasadas antes de ficarem disponíveis para processamento"
  type        = number
  default     = 0
}

variable "sqs_max_message_size" {
  description = "Tamanho máximo da mensagem em bytes (máximo 256 KB)"
  type        = number
  default     = 262144
}

variable "sqs_message_retention_seconds" {
  description = "Tempo em segundos que as mensagens não processadas ficam na fila (mínimo 60 segundos, máximo 14 dias)"
  type        = number
  default     = 345600
}

variable "sqs_receive_wait_time_seconds" {
  description = "Tempo em segundos para long polling (0-20 segundos)"
  type        = number
  default     = 0
}

variable "sqs_visibility_timeout_seconds" {
  description = "Tempo em segundos que uma mensagem fica invisível após ser recebida"
  type        = number
  default     = 30
}

variable "sqs_dead_letter_queue_arn" {
  description = "ARN da Dead Letter Queue (opcional)"
  type        = string
  default     = null
}

variable "sqs_max_receive_count" {
  description = "Número máximo de tentativas antes de enviar para DLQ"
  type        = number
  default     = 3
}

variable "sqs_kms_master_key_id" {
  description = "ID da chave KMS para criptografia (opcional)"
  type        = string
  default     = null
}

variable "sqs_enable_queue_policy" {
  description = "Habilitar política de acesso customizada para a fila"
  type        = bool
  default     = false
}

variable "sqs_queue_policy" {
  description = "Política JSON para controle de acesso à fila"
  type        = string
  default     = null
}