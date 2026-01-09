variable "sg_bastion_name" {
  type        = string
  description = "Name of the bastion security group"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "allowed_ssh_cidr" {
  type        = string
  description = "CIDR block allowed to SSH to bastion (e.g., 0.0.0.0/0 for anywhere, or your IP)"
  default     = "0.0.0.0/0"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
  default     = {}
}
