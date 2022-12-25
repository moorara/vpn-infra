# https://developer.hashicorp.com/terraform/language/values/variables
# https://developer.hashicorp.com/terraform/language/expressions/type-constraints

variable "credentials_file" {
  type    = string
  default = "./account.json"
}

variable "project" {
  description = "A Google Cloud project to associate the GCS bucket with."
  type        = string
  nullable    = false
}

variable "location" {
  description = "A Google Cloud location to associate the GCS bucket with."
  type        = string
  nullable    = false
}

variable "domain" {
  description = "A domain name for the GCS bucket name."
  type        = string
  nullable    = false
}
