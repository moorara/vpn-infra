# ====================================================================================================
#  RESOURCES
# ====================================================================================================

# https://registry.terraform.io/providers/hashicorp/google/latest/docs
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_versions
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference
provider "google" {
  credentials = file(var.credentials_file)
  project     = var.project
  region      = var.region
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
resource "google_compute_network" "vpn" {
  name                    = "${var.name}-vpn-network"
  project                 = var.project
  routing_mode            = "REGIONAL"
  auto_create_subnetworks = false
}
