variable "project_id" {
  type        = string
  description = "Existing Google Cloud project ID."
}
variable "name" {
  type        = string
  description = "Cloud Storage bucket name for the native google_storage_bucket."
}
variable "region" {
  type        = string
  description = "Google Cloud region."
}
variable "labels" {
  type = map(string)
  default = {

  }
  description = "Resource labels."
}
variable "storage_class" {
  type        = string
  default     = "STANDARD"
  description = "Cloud Storage class."
}
variable "kms_key_name" {
  type        = string
  default     = null
  description = "Optional CMEK key name; caller must grant Cloud Storage service agent access."
}
variable "retention_period_seconds" {
  type        = number
  default     = null
  description = "Optional retention period in seconds; null leaves retention unconfigured."
}
