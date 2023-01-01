# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account
resource "google_service_account" "vpn" {
  account_id   = "vpn-${var.name}"
  project      = var.project
  display_name = "VPN Service Account"
}
