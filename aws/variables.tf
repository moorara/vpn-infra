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

variable "instance_type" {
  description = "The AWS EC2 instance type for VPN servers."
  type        = string
  nullable    = false
  default     = "t2.micro"
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
