provider "aws" {
  profile = "default"
  region  = "us-east-1"
}
# The VPC
resource "aws_vpc" "the_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "THE-VPC"
  }
}

# IGW
resource "aws_internet_gateway" "the_igw" {
  cidr_block = ""
  vpc_id = aws_vpc.new_vpc.id
  tags = {
    Name = "THE-IGW"
  }
}

# The Subnets
resource "aws_subnet" "public_a" {
  cidr_block = "10.0.0.0/24"
  vpc_id = aws_vpc.new_vpc.id
  availability_zone = "us-east-1a"
  tags = {
    Name = "Public-A"
  }
}

resource "aws_subnet" "public_b" {
  cidr_block = "10.0.1.0/24"
  vpc_id = aws_vpc.new_vpc.id
  availability_zone = "us-east-1b"
  tags = {
    Name = "Public-B"
  }
}

resource "aws_subnet" "private_a" {
  cidr_block = "10.0.2.0/24"
  vpc_id = aws_vpc.new_vpc.id
  availability_zone = "us-east-1a"
  tags = {
    Name = "Private-A"
  }
}

resource "aws_subnet" "private_b" {
  cidr_block = "10.0.3.0/24"
  vpc_id = aws_vpc.new_vpc.id
  availability_zone = "us-east-1b"
  tags = {
    Name = "Private-B"
  }
}

resource "aws_subnet" "protected_a" {
  cidr_block = "10.0.4.0/24"
  vpc_id = aws_vpc.new_vpc.id
  availability_zone = "us-east-1a"
  tags = {
    Name = "Protected-A"
  }
}

resource "aws_subnet" "protected_b" {
  cidr_block = "10.0.5.0/24"
  vpc_id = aws_vpc.new_vpc.id
  availability_zone = "us-east-1b"
  tags = {
    Name = "Protected-B"
  }
}

# Route Tables
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.the_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.the_igw.id
  }
}

# This is where if we added a NAT, we would associate the NAT.
resource "aws_route_table" "private_protected_route_table" {
  vpc_id = aws_vpc.the_vpc.id
}

resource "aws_route_table_association" "public_a_association" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id = aws_subnet.public_a
}

resource "aws_route_table_association" "public_b_association" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id = aws_subnet.public_b
}

resource "aws_route_table_association" "private_a_association" {
  route_table_id = aws_route_table.private_protected_route_table.id
  subnet_id = aws_subnet.private_a
}

resource "aws_route_table_association" "private_b_association" {
  route_table_id = aws_route_table.private_protected_route_table.id
  subnet_id = aws_subnet.private_b
}

resource "aws_route_table_association" "protected_a_association" {
  route_table_id = aws_route_table.private_protected_route_table.id
  subnet_id = aws_subnet.protected_a
}

resource "aws_route_table_association" "protected_b_association" {
  route_table_id = aws_route_table.private_protected_route_table.id
  subnet_id = aws_subnet.protected_b.id
}

resource "aws_network_acl" "public_nacl" {
  vpc_id = aws_vpc.the_vpc.id
  subnet_ids = [
    aws_subnet.public_a,
    aws_subnet.public_b
  ]
}

# TODO: In production this rule should be limited
# THIS RULE IS NOT SECURE.  FOR TEACHING PURPOSES ONLY
resource "aws_network_acl_rule" "bad_public_tcp_rule" {
  network_acl_id = aws_network_acl.public_nacl.id
  protocol = "tcp"
  rule_action = "allow"
  rule_number = 100
  cidr_block = "0.0.0.0/0"
  from_port = 0
  to_port = 1023
}

resource "aws_network_acl_rule" "bad_public_udp_rule" {
  network_acl_id = aws_network_acl.public_nacl.id
  protocol = "udp"
  rule_action = "allow"
  rule_number = 101
  cidr_block = "0.0.0.0/0"
  from_port = 0
  to_port = 1023
}

resource "aws_network_acl_rule" "public_ephermal_tcp" {
  network_acl_id = aws_network_acl.public_nacl.id
  protocol = "tcp"
  rule_action = "allow"
  rule_number = 1000
  from_port = 1024
  to_port = 65535
}

resource "aws_network_acl_rule" "public_ephermal_udp" {
  network_acl_id = aws_network_acl.public_nacl.id
  protocol = "udp"
  rule_action = "allow"
  rule_number = 1001
  from_port = 1024
  to_port = 65535
}

resource "aws_network_acl" "private_nacl"{
  vpc_id = aws_vpc.the_vpc.id
  subnet_ids = [
    aws_subnet.private_a,
    aws_subnet.private_b
  ]
}

# TODO: In production this rule should be limited
# THIS RULE IS NOT SECURE.  FOR TEACHING PURPOSES ONLY
resource "aws_network_acl_rule" "bad_private_tcp_rule" {
  network_acl_id = aws_network_acl.private_nacl.id
  protocol = "tcp"
  rule_action = "allow"
  rule_number = 100
  cidr_block = "0.0.0.0/0"
  from_port = 0
  to_port = 1023
}

resource "aws_network_acl_rule" "bad_private_udp_rule" {
  network_acl_id = aws_network_acl.private_nacl.id
  protocol = "udp"
  rule_action = "allow"
  rule_number = 101
  cidr_block = "0.0.0.0/0"
  from_port = 0
  to_port = 1023
}

resource "aws_network_acl_rule" "private_ephermal_tcp" {
  network_acl_id = aws_network_acl.private_nacl.id
  protocol = "tcp"
  rule_action = "allow"
  rule_number = 1000
  from_port = 1024
  to_port = 65535
}

resource "aws_network_acl_rule" "private_ephermal_udp" {
  network_acl_id = aws_network_acl.private_nacl.id
  protocol = "udp"
  rule_action = "allow"
  rule_number = 1001
  from_port = 1024
  to_port = 65535
}

resource "aws_network_acl" "protected_nacl" {
  vpc_id = aws_vpc.the_vpc.id
  subnet_ids = [
    aws_subnet.protected_a,
    aws_subnet.protected_b
  ]
}

# TODO: In production this rule should be limited
# THIS RULE IS NOT SECURE.  FOR TEACHING PURPOSES ONLY
resource "aws_network_acl_rule" "bad_protected_tcp_rule" {
  network_acl_id = aws_network_acl.protected_nacl.id
  protocol = "tcp"
  rule_action = "allow"
  rule_number = 100
  cidr_block = "0.0.0.0/0"
  from_port = 0
  to_port = 1023
}

resource "aws_network_acl_rule" "bad_protected_udp_rule" {
  network_acl_id = aws_network_acl.protected_nacl.id
  protocol = "udp"
  rule_action = "allow"
  rule_number = 101
  cidr_block = "0.0.0.0/0"
  from_port = 0
  to_port = 1023
}

resource "aws_network_acl_rule" "protected_ephermal_tcp" {
  network_acl_id = aws_network_acl.protected_nacl.id
  protocol = "tcp"
  rule_action = "allow"
  rule_number = 1000
  from_port = 1024
  to_port = 65535
}

resource "aws_network_acl_rule" "protected_ephermal_udp" {
  network_acl_id = aws_network_acl.protected_nacl.id
  protocol = "udp"
  rule_action = "allow"
  rule_number = 1001
  from_port = 1024
  to_port = 65535
}