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
  }

  # https://developer.hashicorp.com/terraform/language/settings/backends/s3
  backend "s3" {
    key = "dns/terraform.tfstate"
  }
}
