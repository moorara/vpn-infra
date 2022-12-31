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
  description = "A human-readable name for the deployment."
  type        = string
  nullable    = false
}

variable "subdomain" {
  description = "A subdomain for accessing the VPN server."
  type        = string
  nullable    = false
}

variable "acme_email" {
  description = "An email address for registering an account with ACME."
  type        = string
  nullable    = false
}

variable "incoming_icmp" {
  description = "Configurations for incoming ICMP traffic."
  type = object({
    enabled = bool
    cidrs   = set(string)
  })
  default = {
    enabled = false
    cidrs   = [ "0.0.0.0/0" ]
  }
}

variable "incoming_ssh" {
  description = "Configurations for incoming SSH traffic."
  type = object({
    enabled = bool
    cidrs   = set(string)
  })
  default = {
    enabled = true
    cidrs   = [ "0.0.0.0/0" ]
  }
}

variable "incoming_http" {
  description = "Configurations for incoming HTTP traffic."
  type = object({
    enabled = bool
    cidrs   = set(string)
  })
  default = {
    enabled = true
    cidrs   = [ "0.0.0.0/0" ]
  }
}

variable "incoming_https" {
  description = "Configurations for incoming HTTPS traffic."
  type = object({
    enabled = bool
    cidrs   = set(string)
  })
  default = {
    enabled = true
    cidrs   = [ "0.0.0.0/0" ]
  }
}

variable "incoming_v2ray" {
  description = "Configurations for incoming V2Ray traffic."
  type = object({
    enabled   = bool
    from_port = number
    to_port   = number
    cidrs     = set(string)
  })
  default = {
    enabled   = true
    from_port = 4000
    to_port   = 9999
    cidrs     = [ "0.0.0.0/0" ]
  }
}

variable "instance_type" {
  description = "The AWS EC2 instance type for VPN servers."
  type        = string
  nullable    = false
  default     = "m5.large"
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
