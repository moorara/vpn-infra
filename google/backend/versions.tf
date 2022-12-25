# https://developer.hashicorp.com/terraform/language/settings
# https://developer.hashicorp.com/terraform/language/expressions/version-constraints

terraform {
  # Root modules should constraint both a lower and upper bound on versions for each provider.
  required_version = "~> 1.3"

  required_providers {
    # https://registry.terraform.io/providers/hashicorp/google/latest/docs
    google = {
      source  = "hashicorp/google"
      version = "~> 4.47"
    }
  }
}
