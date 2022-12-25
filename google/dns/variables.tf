# https://developer.hashicorp.com/terraform/language/values/variables
# https://developer.hashicorp.com/terraform/language/expressions/type-constraints

variable "credentials_file" {
  type    = string
  default = "./account.json"
}

variable "project" {
  description = "A Google Cloud project to manage deployment resources in."
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
