# ====================================================================================================
#  NETWORKING
# ====================================================================================================

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs
provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones
data "aws_availability_zones" "available" {
  state = "available"
}

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

# ====================================================================================================
#  Identity and Access Management (IAM)
# ====================================================================================================

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile
resource "aws_iam_instance_profile" "vpn" {
  name = "${var.name}-vpn"
  role = aws_iam_role.vpn.name

  tags = {
    Name = "${var.name}-vpn"
  }

  lifecycle {
    ignore_changes = [ tags ]
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
resource "aws_iam_role" "vpn" {
  name = "${var.name}-vpn"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })

  tags = {
    Name = "${var.name}-vpn"
  }

  lifecycle {
    ignore_changes = [ tags ]
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy
resource "aws_iam_role_policy" "vpn" {
  name = "${var.name}-vpn"
  role = aws_iam_role.vpn.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Resource = "*"
      Action: [
        "ec2:Describe*"
      ]
    }]
  })
}

# ====================================================================================================
#  VM INSTANCES
# ====================================================================================================

# https://wiki.debian.org/Cloud/AmazonEC2Image
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami
data "aws_ami" "debian" {
  most_recent = true
  owners      = [ "136693071363" ]

  filter {
    name   = "name"
    values = [ "debian-11-amd64-*" ]
  }

  filter {
    name   = "virtualization-type"
    values = [ "hvm" ]
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair
resource "aws_key_pair" "vpn" {
  key_name   = "${var.name}-vpn"
  public_key = file(var.ssh_public_key_file)

  tags = {
    Name = "${var.name}-vpn"
  }

  lifecycle {
    ignore_changes = [ tags ]
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template
resource "aws_launch_template" "vpn" {
  name                                 = "${var.name}-vpn"
  image_id                             = data.aws_ami.debian.id
  instance_type                        = var.instance_type
  key_name                             = aws_key_pair.vpn.key_name
  user_data                            = filebase64("${path.module}/bootstrap.sh")
  instance_initiated_shutdown_behavior = "terminate"

  iam_instance_profile {
    name = aws_iam_instance_profile.vpn.name
  }

  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    security_groups             = [ aws_security_group.vpn.id ]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.name}-vpn"
    }
  }

  tags = {
    Name = "${var.name}-vpn"
  }

  lifecycle {
    ignore_changes = [
      tags,
      tag_specifications.0.tags,
    ]
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "vpn" {
  subnet_id = aws_subnet.vpn.0.id

  launch_template {
    id      = aws_launch_template.vpn.id
    version = "$Latest"
  }
}

# https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file
data "template_file" "ssh_config" {
  template = file("${path.module}/sshconfig.tpl")
  vars = {
    address     = aws_instance.vpn.public_ip
    private_key = basename(var.ssh_private_key_file)
  }
}

# https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file
resource "local_file" "ssh_config" {
  filename = pathexpand(format("%s/config-%s",
    dirname(var.ssh_private_key_file),
    var.name,
  ))

  content              = data.template_file.ssh_config.rendered
  file_permission      = "0644"
  directory_permission = "0700"
}
