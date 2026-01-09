resource "aws_network_acl" "this" {
  vpc_id = var.vpc_id
  tags   = merge({ Name = var.acl_name }, var.tags)
}

resource "aws_network_acl_rule" "allow_tcp_ephemeral_inbound" {
  network_acl_id = aws_network_acl.this.id
  rule_number    = 90
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

resource "aws_network_acl_rule" "allow_http" {
  network_acl_id = aws_network_acl.this.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

resource "aws_network_acl_rule" "allow_https" {
  network_acl_id = aws_network_acl.this.id
  rule_number    = 110
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

resource "aws_network_acl_rule" "allow_dns_udp_inbound" {
  network_acl_id = aws_network_acl.this.id
  rule_number    = 70
  egress         = false
  protocol       = "udp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 53
  to_port        = 53
}

resource "aws_network_acl_rule" "allow_dns_tcp_inbound" {
  network_acl_id = aws_network_acl.this.id
  rule_number    = 75
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 53
  to_port        = 53
}

resource "aws_network_acl_rule" "allow_dns_udp_outbound" {
  network_acl_id = aws_network_acl.this.id
  rule_number    = 70
  egress         = true
  protocol       = "udp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 53
  to_port        = 53
}

resource "aws_network_acl_rule" "allow_dns_tcp_outbound" {
  network_acl_id = aws_network_acl.this.id
  rule_number    = 75
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 53
  to_port        = 53
}

resource "aws_network_acl_rule" "allow_all_egress" {
  network_acl_id = aws_network_acl.this.id
  rule_number    = 200
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_association" "this" {
  network_acl_id = aws_network_acl.this.id
  subnet_id      = var.subnet_id
}
