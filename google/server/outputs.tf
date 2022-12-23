# https://developer.hashicorp.com/terraform/language/values/outputs

output "panel_url" {
  value       = "https://${var.subdomain}"
  description = "The URL for accessing the X-UI admin panel."
}

output "panel_username" {
  value       = local.panel_username
  description = "The username for accessing the X-UI admin panel."
}

output "panel_password" {
  value       = local.panel_password
  description = "The password for accessing the X-UI admin panel."
  sensitive   = true
}
