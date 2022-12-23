# ====================================================================================================
#  NETWORKS
# ====================================================================================================

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
resource "aws_vpc" "vpn" {
  cidr_block           = lookup(local.network_cidrs, var.region)
  enable_dns_support   = true
  enable_dns_hostnames = false

  tags = {
    Name   = "${var.name}-vpn-network"
    Region = var.region
  }

  # https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle#ignore_changes
  lifecycle {
    ignore_changes = [ tags ]
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "vpn" {
  count = length(data.aws_availability_zones.available.names)

  vpc_id            = aws_vpc.vpn.id
  cidr_block        = cidrsubnet(lookup(local.network_cidrs, var.region), 4, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name   = format("%s-vpn-subnet-%d", var.name, count.index + 1)
    Region = var.region
  }

  # https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle#ignore_changes
  lifecycle {
    ignore_changes = [ tags ]
  }
}

# ====================================================================================================
#  ROUTERS
# ====================================================================================================

# https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
resource "aws_internet_gateway" "vpn" {
  vpc_id = aws_vpc.vpn.id

  tags = {
    Name   = "${var.name}-vpn"
    Region = var.region
  }

  # https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle#ignore_changes
  lifecycle {
    ignore_changes = [ tags ]
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
resource "aws_route_table" "vpn" {
  vpc_id = aws_vpc.vpn.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpn.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.vpn.id
  }

  tags = {
    Name   = "${var.name}-vpn"
    Region = var.region
  }

  # https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle#ignore_changes
  lifecycle {
    ignore_changes = [ tags ]
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
resource "aws_route_table_association" "vpn" {
  count = length(data.aws_availability_zones.available.names)

  subnet_id      = element(aws_subnet.vpn.*.id, count.index)
  route_table_id = aws_route_table.vpn.id
}

# ====================================================================================================
#  FIREWALL RULES
# ====================================================================================================

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "vpn" {
  name   = "${var.name}-vpn"
  vpc_id = aws_vpc.vpn.id

  egress {
    protocol    = "all"
    from_port   = 0
    to_port     = 0
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "Allow all outgoing traffic to the Internet."
  }

  ingress {
    protocol    = "all"
    from_port   = 0
    to_port     = 0
    cidr_blocks = [ aws_vpc.vpn.cidr_block ]
    description = "Allow all incoming traffic inside the VPC."
  }

  ingress {
    protocol    = "icmp"
    from_port   = 8 # ICMP type number
    to_port     = 0 # ICMP code
    cidr_blocks = var.icmp_incoming_cidrs
    description = "Allow icmp access from trusted addresses."
  }

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = var.ssh_incoming_cidrs
    description = "Allow ssh access from trusted addresses."
  }

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = var.http_incoming_cidrs
    description = "Allow http access from trusted addresses."
  }

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = var.https_incoming_cidrs
    description = "Allow https access from trusted addresses."
  }

  tags = {
    Name = "${var.name}-vpn"
  }

  # https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle#create_before_destroy
  # https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle#ignore_changes
  lifecycle {
    create_before_destroy = true
    ignore_changes = [ tags ]
  }
}
