# https://developer.hashicorp.com/terraform/language/values/outputs

output "bucket" {
  description = "The name of created GCS bucket."
  value       = google_storage_bucket.backend.name
}
