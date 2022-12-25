# https://developer.hashicorp.com/terraform/language/values/outputs

output "bucket" {
  description = "The name of created S3 bucket."
  value       = aws_s3_bucket.backend.id
}
