output "bastion_sg_id" {
  description = "ID of the bastion security group"
  value       = aws_security_group.bastion.id
}

output "bastion_sg_arn" {
  description = "ARN of the bastion security group"
  value       = aws_security_group.bastion.arn
}
