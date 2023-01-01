# https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password
resource "random_password" "panel" {
  length  = 16
  lower   = true
  upper   = true
  numeric = true
  special = false
}

# https://developer.hashicorp.com/terraform/language/values/locals
locals {
  # X-UI configs
  panel_port     = 80
  panel_username = "admin"
  panel_password = random_password.panel.result

  vpn_subnetwork_tag  = "vpn-${name}"
  vpn_subnetwork_cidr = cidrsubnet(lookup(local.network_cidrs, var.region), 4, 0)

  # https://en.wikipedia.org/wiki/Classful_network
  # https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing
  network_cidrs = {
    asia-east1              = "10.10.0.0/16"
    asia-east2              = "10.11.0.0/16"
    asia-northeast1         = "10.12.0.0/16"
    asia-northeast2         = "10.13.0.0/16"
    asia-northeast3         = "10.14.0.0/16"
    asia-south1             = "10.15.0.0/16"
    asia-south2             = "10.16.0.0/16"
    asia-southeast1         = "10.17.0.0/16"
    asia-southeast2         = "10.18.0.0/16"
    australia-southeast1    = "10.19.0.0/16"
    australia-southeast2    = "10.20.0.0/16"
    europe-central2         = "10.21.0.0/16"
    europe-north1           = "10.22.0.0/16"
    europe-southwest1       = "10.23.0.0/16"
    europe-west1            = "10.24.0.0/16"
    europe-west2            = "10.25.0.0/16"
    europe-west3            = "10.26.0.0/16"
    europe-west4            = "10.27.0.0/16"
    europe-west6            = "10.28.0.0/16"
    europe-west8            = "10.29.0.0/16"
    europe-west9            = "10.30.0.0/16"
    me-west1                = "10.31.0.0/16"
    northamerica-northeast1 = "10.32.0.0/16"
    northamerica-northeast2 = "10.33.0.0/16"
    southamerica-east1      = "10.34.0.0/16"
    southamerica-west1      = "10.35.0.0/16"
    us-central1             = "10.36.0.0/16"
    us-east1                = "10.37.0.0/16"
    us-east4                = "10.38.0.0/16"
    us-east5                = "10.39.0.0/16"
    us-south1               = "10.40.0.0/16"
    us-west1                = "10.41.0.0/16"
    us-west2                = "10.42.0.0/16"
    us-west3                = "10.43.0.0/16"
    us-west4                = "10.44.0.0/16"
  }
}
