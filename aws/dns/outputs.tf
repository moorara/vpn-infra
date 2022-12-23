# https://developer.hashicorp.com/terraform/language/values/outputs

output "subdomains" {
  description = "The names of available subdomains."
  value       = [ for name in var.names: "${name}.${var.domain}" ]
}
