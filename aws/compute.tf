# ====================================================================================================
#  LAUNCH TEMPLATES
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

# ====================================================================================================
#  VM INSTANCES
# ====================================================================================================

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "vpn" {
  subnet_id = aws_subnet.vpn.0.id

  launch_template {
    id      = aws_launch_template.vpn.id
    version = "$Latest"
  }
}

# ====================================================================================================
#  SSH CONFIGS
# ====================================================================================================

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
