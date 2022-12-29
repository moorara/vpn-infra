# https://developer.hashicorp.com/terraform/language/values/variables
# https://developer.hashicorp.com/terraform/language/expressions/type-constraints

variable "access_key" {
  type      = string
  sensitive = true
}

variable "secret_key" {
  type      = string
  sensitive = true
}

variable "region" {
  description = "An AWS region for the S3 bucket."
  type        = string
  nullable    = false
}

variable "domain" {
  description = "A domain name for the S3 bucket."
  type        = string
  nullable    = false
}
