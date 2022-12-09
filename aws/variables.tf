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
  description = "An AWS region to manage deployment resources in."
  type        = string
  nullable    = false
}

variable "name" {
  description = "A human-readable name for the deployment resources."
  type        = string
  nullable    = false
}

variable "ssh_public_key_file" {
  type = string
}

variable "ssh_private_key_file" {
  type = string
}
