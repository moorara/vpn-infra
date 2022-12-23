# https://registry.terraform.io/providers/hashicorp/aws/latest/docs
provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone
data "aws_route53_zone" "main" {
  name = "${var.domain}."
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone
resource "aws_route53_zone" "sub" {
  count = length(var.names)

  name = format("%s.%s", var.names[count.index], var.domain)

  tags = {
    Name = var.names[count.index]
  }

  # https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle#ignore_changes
  lifecycle {
    ignore_changes = [ tags ]
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record
resource "aws_route53_record" "sub_ns" {
  count = length(var.names)

  zone_id = data.aws_route53_zone.main.zone_id
  name    = format("%s.%s", var.names[count.index], var.domain)
  type    = "NS"
  ttl     = 172800
  records = element(aws_route53_zone.sub.*.name_servers, count.index)
}
