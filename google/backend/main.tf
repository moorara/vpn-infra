# https://registry.terraform.io/providers/hashicorp/google/latest/docs
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_versions
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference
provider "google" {
  credentials = file(var.credentials_file)
  project     = var.project
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket
resource "google_storage_bucket" "backend" {
  name                     = replace(var.domain, ".", "-")
  location                 = var.location # https://cloud.google.com/storage/docs/locations
  public_access_prevention = "enforced"
  force_destroy            = true

  versioning {
    enabled = true
  }
}
