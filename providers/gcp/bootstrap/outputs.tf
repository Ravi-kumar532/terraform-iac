output "state_bucket_name" {
  description = "Cloud Storage bucket name for Terraform state."
  value       = google_storage_bucket.terraform_state.name
}

output "state_bucket_name" {
  description = "Cloud Storage bucket name for the Terraform GCS backend."
  value       = google_storage_bucket.terraform_state.name
}

output "state_bucket_url" {
  description = "Cloud Storage bucket URL."
  value       = google_storage_bucket.terraform_state.url
}
