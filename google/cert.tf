# ====================================================================================================
#  CERTIFICATES
# ====================================================================================================

# https://registry.terraform.io/providers/vancluever/acme/latest/docs
provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

# https://registry.terraform.io/providers/vancluever/acme/latest/docs
provider "acme" {
  alias      = "staging"
  server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
}

# https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key
resource "tls_private_key" "vpn" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}

# https://registry.terraform.io/providers/vancluever/acme/latest/docs/resources/registration
resource "acme_registration" "vpn" {
  provider = acme.staging

  account_key_pem = tls_private_key.vpn.private_key_pem
  email_address   = var.acme_email
}

# https://registry.terraform.io/providers/vancluever/acme/latest/docs/resources/certificate
resource "acme_certificate" "vpn" {
  provider = acme.staging

  account_key_pem           = acme_registration.vpn.account_key_pem
  common_name               = var.cert_domain
  subject_alternative_names = var.cert_alt_domains
  min_days_remaining        = 60

  # https://registry.terraform.io/providers/vancluever/acme/latest/docs/resources/certificate#using-dns-challenges
  # https://registry.terraform.io/providers/vancluever/acme/latest/docs/guides/dns-providers-gcloud
  dns_challenge {
    provider = "gcloud"
    config = {
      GCE_SERVICE_ACCOUNT_FILE = var.credentials_file
      GCE_PROJECT              = var.project
    }
  }
}
