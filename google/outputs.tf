# https://developer.hashicorp.com/terraform/language/values/outputs

output "url" {
  value       = ""
  description = "The URL for accessing the X-UI admin panel."
}

output "username" {
  value       = ""
  description = "The username for accessing the X-UI admin panel."
}

output "password" {
  value       = ""
  description = "The password for accessing the X-UI admin panel."
  sensitive   = true
}
