variable "project_id" {
  type        = string
  description = "Existing Google Cloud project ID."
}
variable "name" {
  type        = string
  description = "Cloud Functions gen2 function name for the native google_cloudfunctions2_function."
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
variable "runtime" {
  type        = string
  default     = "python312"
  description = "Supported Cloud Functions gen2 runtime."
}
variable "entry_point" {
  type        = string
  description = "Function entry point name."
}
variable "source_bucket" {
  type        = string
  description = "Existing private source bucket; grant Cloud Build access narrowly."
}
variable "source_object" {
  type        = string
  description = "Immutable source archive object name."
}
variable "service_account_email" {
  type        = string
  description = "Caller-provided runtime service account email."
}
variable "max_instances" {
  type        = number
  default     = 10
  description = "Maximum function instances."
}
variable "min_instances" {
  type        = number
  default     = 1
  description = "Minimum warm instances."
}
variable "memory" {
  type        = string
  default     = "512M"
  description = "Function memory allocation."
}
variable "timeout_seconds" {
  type        = number
  default     = 60
  description = "Function timeout."
}
variable "ingress_settings" {
  type        = string
  default     = "ALLOW_INTERNAL_ONLY"
  description = "Ingress restriction; use ALLOW_ALL only when public access is intended. Invocation IAM is caller-managed."
}
