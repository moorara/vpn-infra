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
  description = "An AWS region for the S3 bucket to be used as Terraform backend."
  type        = string
  nullable    = false
}

variable "domain" {
  description = "A domain name to be used as suffix for creating subdomains."
  type        = string
  nullable    = false
}

variable "names" {
  description = "A list of names to be used as prefix for creating subdomains."
  type        = list(string)
  nullable    = false
}