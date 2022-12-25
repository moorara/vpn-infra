# https://developer.hashicorp.com/terraform/language/settings
# https://developer.hashicorp.com/terraform/language/expressions/version-constraints
# https://developer.hashicorp.com/terraform/language/settings/backends/configuration

terraform {
  # Root modules should constraint both a lower and upper bound on versions for each provider.
  required_version = "~> 1.3"

  required_providers {
    # https://registry.terraform.io/providers/hashicorp/aws/latest/docs
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.48"
    }
    # https://registry.terraform.io/providers/vancluever/acme/latest/docs
    acme = {
      source  = "vancluever/acme"
      version = "~> 2.12"
    }
    # https://registry.terraform.io/providers/hashicorp/tls/latest/docs
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    # https://registry.terraform.io/providers/hashicorp/local/latest/docs
    local = {
      source  = "hashicorp/local"
      version = "~> 2.2"
    }
    # https://registry.terraform.io/providers/hashicorp/random/latest/docs
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4"
    }
  }

  # https://developer.hashicorp.com/terraform/language/settings/backends/s3
  backend "s3" {}
}
