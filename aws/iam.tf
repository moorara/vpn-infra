# ====================================================================================================
#  PROFILES
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

# ====================================================================================================
#  ROLES
# ====================================================================================================

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
