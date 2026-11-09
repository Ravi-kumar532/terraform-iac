variable "project_id" {
  type        = string
  description = "Existing Google Cloud project ID."
}
variable "name" {
  type        = string
  description = "Artifact Registry repository name for the native google_artifact_registry_repository."
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
variable "description" {
  type        = string
  default     = ""
  description = "Repository description."
}
variable "kms_key_name" {
  type        = string
  default     = null
  description = "Optional CMEK key name; grant the Artifact Registry service agent access."
}
variable "keep_recent_versions" {
  type        = number
  default     = 30
  description = "Number of recent versions retained by cleanup policy."
}
