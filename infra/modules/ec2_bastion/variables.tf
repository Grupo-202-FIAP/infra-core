variable "bastion_instance_name" {
  type        = string
  description = "Name of the bastion EC2 instance"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type for bastion"
  default     = "t3.micro"
}

variable "public_subnet_id" {
  type        = string
  description = "Public subnet ID where bastion will be deployed"
}

variable "bastion_sg_id" {
  type        = string
  description = "Security group ID for bastion host"
}

variable "key_pair_name" {
  type        = string
  description = "Name of the SSH key pair to use for the bastion instance"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
  default     = {}
}
