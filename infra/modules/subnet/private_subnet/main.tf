resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = var.vpc_id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = merge({ Name = "${var.subnet_name}-private-${count.index}" }, var.tags)
}

resource "aws_db_subnet_group" "rds_private_group" {
  name       = var.subnet_group_name

  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name = "infra-subnet-private"
  }
}