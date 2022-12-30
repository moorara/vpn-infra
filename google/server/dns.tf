# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/dns_managed_zone
data "google_dns_managed_zone" "subdomain" {
  name = replace(var.subdomain, ".", "-")
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_record_set
resource "google_dns_record_set" "frontend" {
  managed_zone = data.google_dns_managed_zone.subdomain.name
  name         = "${var.subdomain}."
  type         = "A"
  ttl          = 300
  rrdatas      = [ google_compute_instance_from_template.vpn.network_interface.0.access_config.0.nat_ip ]
}
