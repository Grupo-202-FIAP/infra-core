output "bastion_instance_id" {
  value       = aws_instance.bastion.id
  description = "EC2 Bastion instance ID"
}

output "bastion_private_ip" {
  value       = aws_instance.bastion.private_ip
  description = "Private IP address of the bastion instance"
}

output "bastion_public_ip" {
  value       = aws_eip.bastion.public_ip
  description = "Elastic IP address of the bastion instance"
}

output "bastion_eip_id" {
  value       = aws_eip.bastion.id
  description = "Elastic IP ID of the bastion instance"
}

output "bastion_security_group_id" {
  value       = aws_instance.bastion.security_groups[0]
  description = "Security group ID of the bastion instance"
}
