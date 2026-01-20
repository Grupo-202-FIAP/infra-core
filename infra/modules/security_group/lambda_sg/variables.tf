variable "sg_lambda_name" {
  type        = string
  description = "Name of the lambda security group"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
  default     = {}
}
