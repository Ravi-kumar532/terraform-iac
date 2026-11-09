variable "project_id" {
  type        = string
  description = "Existing Google Cloud project ID."
}
variable "name" {
  type        = string
  description = "Cloud Run service name for the native google_cloud_run_v2_service."
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
variable "container_image" {
  type        = string
  description = "Container image URI in Artifact Registry or another supported registry."
}
variable "service_account_email" {
  type        = string
  description = "Caller-provided runtime service account email with least-privilege permissions."
}
variable "ingress" {
  type        = string
  default     = "INGRESS_TRAFFIC_INTERNAL_ONLY"
  description = "Ingress mode; choose all only when public access is explicitly intended. IAM invoker bindings are caller-managed."
}
variable "min_instances" {
  type        = number
  default     = 1
  description = "Minimum serving instances."
}
variable "max_instances" {
  type        = number
  default     = 10
  description = "Maximum serving instances."
}
variable "container_port" {
  type        = number
  default     = 8080
  description = "Container listener port."
}
variable "cpu" {
  type        = string
  default     = "1"
  description = "CPU limit."
}
variable "memory" {
  type        = string
  default     = "512Mi"
  description = "Memory limit."
}
variable "environment_variables" {
  type = map(string)
  default = {

  }
  description = "Non-secret environment variables only; never put secrets here."
}
variable "deletion_protection" {
  type        = bool
  default     = true
  description = "Prevent accidental service deletion."
}
