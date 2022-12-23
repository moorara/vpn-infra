# ====================================================================================================
#  ZONES
# ====================================================================================================

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone
data "aws_route53_zone" "main" {
  name = "${var.domain}."
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone
resource "aws_route53_zone" "sub" {
  name = local.subdomain

  tags = {
    Name = var.name
  }

  # https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle#ignore_changes
  lifecycle {
    ignore_changes = [ tags ]
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record
resource "aws_route53_record" "sub_ns" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = local.subdomain
  type    = "NS"
  ttl     = 172800
  records = aws_route53_zone.sub.name_servers
}
