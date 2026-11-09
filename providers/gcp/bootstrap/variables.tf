variable "project_id" {
  description = "Google Cloud project ID for Terraform state."
  type        = string
}

variable "region" {
  description = "Google Cloud region."
  type        = string
}

variable "state_bucket_name" {
  description = "Globally unique Cloud Storage bucket name for Terraform state."
  type        = string
}

variable "location" {
  description = "Cloud Storage bucket location."
  type        = string
}

variable "force_destroy" {
  description = "Whether to permit deleting a non-empty state bucket; keep false outside disposable development."
  type        = bool
  default     = false
}
