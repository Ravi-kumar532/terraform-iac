output "state_bucket_name" {
  description = "Cloud Storage bucket name for Terraform state."
  value       = google_storage_bucket.terraform_state.name
}
