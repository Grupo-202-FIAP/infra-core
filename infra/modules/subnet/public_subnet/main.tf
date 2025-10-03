resource "aws_subnet" "public" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.public_subnets
  availability_zone       = var.azs[0]
  map_public_ip_on_launch = true

  tags = merge({ Name = "${var.subnet_name}-public" }, var.tags)
}
