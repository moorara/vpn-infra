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
  description = "A domain name registered with Google Cloud."
  type        = string
  nullable    = false
}

variable "names" {
  description = "A list of names to create a subdomain for each."
  type        = list(string)
  nullable    = false
}
