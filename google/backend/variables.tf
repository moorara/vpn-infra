# https://developer.hashicorp.com/terraform/language/values/variables
# https://developer.hashicorp.com/terraform/language/expressions/type-constraints

variable "credentials_file" {
  type    = string
  default = "./account.json"
}

variable "project" {
  description = "A Google Cloud project for the GCS bucket."
  type        = string
  nullable    = false
}

variable "location" {
  description = "A Google Cloud location for the GCS bucket."
  type        = string
  nullable    = false
}

variable "domain" {
  description = "A domain name for the GCS bucket."
  type        = string
  nullable    = false
}
