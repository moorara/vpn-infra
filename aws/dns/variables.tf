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

variable "domain" {
  description = "A domain name registered with AWS."
  type        = string
  nullable    = false
}

variable "names" {
  description = "A list of names to create a subdomain for each."
  type        = list(string)
  nullable    = false
}
