# 🔹 Data source to get the latest Ubuntu 22.04 LTS AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# 🔹 EC2 Bastion Instance
resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.bastion_sg_id]
  key_name               = var.key_pair_name

  monitoring              = true
  associate_public_ip_address = true

  tags = merge(
    {
      Name = var.bastion_instance_name
    },
    var.tags
  )
}

# 🔹 Elastic IP for Bastion Host
resource "aws_eip" "bastion" {
  instance = aws_instance.bastion.id
  domain   = "vpc"

  tags = merge(
    {
      Name = "${var.bastion_instance_name}-eip"
    },
    var.tags
  )

  depends_on = [aws_instance.bastion]
}
