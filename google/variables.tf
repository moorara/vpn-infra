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

variable "region" {
  description = "A Google Cloud region to manage deployment resources in."
  type        = string
  nullable    = false
}

variable "name" {
  description = "A human-readable name for the deployment resources."
  type        = string
  nullable    = false
}

variable "domain" {
  description = "A domain name for the deployment."
  type        = string
  nullable    = false
}

variable "email" {
  description = "An email address for the deployment."
  type        = string
  nullable    = false
}

variable "icmp_incoming_cidrs" {
  description = "A set of trusted CIDR blocks for incoming ICMP traffic."
  type        = set(string)
  nullable    = false
  default     = [ "0.0.0.0/0" ]
}

variable "ssh_incoming_cidrs" {
  description = "A set of trusted CIDR blocks for incoming SSH traffic."
  type        = set(string)
  nullable    = false
  default     = [ "0.0.0.0/0" ]
}

variable "http_incoming_cidrs" {
  description = "A set of trusted CIDR blocks for incoming HTTP traffic."
  type        = set(string)
  nullable    = false
  default     = [ "0.0.0.0/0" ]
}

variable "https_incoming_cidrs" {
  description = "A set of trusted CIDR blocks for incoming HTTPS traffic."
  type        = set(string)
  nullable    = false
  default     = [ "0.0.0.0/0" ]
}

variable "machine_type" {
  description = "The Google Cloud machine type for VPN servers."
  type        = string
  nullable    = false
  default     = "e2-micro"
}

variable "ssh_public_key_file" {
  description = "The path to the public key file for SSH access."
  type        = string
  nullable    = false
}

variable "ssh_private_key_file" {
  description = "The path to the private key file for SSH access."
  type        = string
  nullable    = false
}
