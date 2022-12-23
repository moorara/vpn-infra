# ====================================================================================================
#  ZONES
# ====================================================================================================

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/dns_managed_zone
data "google_dns_managed_zone" "main" {
  name = replace(var.domain, ".", "-")
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_managed_zone
resource "google_dns_managed_zone" "sub" {
  name        = replace(local.subdomain, ".", "-")
  dns_name    = local.subdomain

  labels = {
    name = var.name
  }

  # https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle#ignore_changes
  lifecycle {
    ignore_changes = [ labels ]
  }
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_record_set
resource "google_dns_record_set" "sub_ns" {
  managed_zone = data.google_dns_managed_zone.main.name
  name         = local.subdomain
  type         = "NS"
  ttl          = 21600
  rrdatas      = google_dns_managed_zone.sub.name_servers
}
