# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone
data "aws_route53_zone" "subdomain" {
  name = "${var.subdomain}."
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record
resource "aws_route53_record" "vpn" {
  zone_id = data.aws_route53_zone.subdomain.zone_id
  name    = var.subdomain
  type    = "A"
  ttl     = 300
  records = [ aws_instance.vpn.public_ip ]
}
