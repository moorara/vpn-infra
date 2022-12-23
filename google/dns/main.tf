# https://registry.terraform.io/providers/hashicorp/google/latest/docs
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_versions
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference
provider "google" {
  credentials = file(var.credentials_file)
  project     = var.project
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/dns_managed_zone
data "google_dns_managed_zone" "main" {
  name = replace(var.domain, ".", "-")
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_managed_zone
resource "google_dns_managed_zone" "sub" {
  count = length(var.names)

  name     = replace(format("%s.%s", var.names[count.index], var.domain), ".", "-")
  dns_name = format("%s.%s.", var.names[count.index], var.domain)

  labels = {
    name = var.names[count.index]
  }

  # https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle#ignore_changes
  lifecycle {
    ignore_changes = [ labels ]
  }
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_record_set
resource "google_dns_record_set" "sub_ns" {
  count = length(var.names)

  managed_zone = data.google_dns_managed_zone.main.name
  name         = format("%s.%s.", var.names[count.index], var.domain)
  type         = "NS"
  ttl          = 21600
  rrdatas      = element(google_dns_managed_zone.sub.*.name_servers, count.index)
}
