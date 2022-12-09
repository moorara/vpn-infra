# ====================================================================================================
#  RESOURCES
# ====================================================================================================

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs
provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
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
