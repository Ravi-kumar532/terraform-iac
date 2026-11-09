variable "project_id" {
  description = "Google Cloud project ID."
  type        = string
}

variable "region" {
  description = "Google Cloud region."
  type        = string
}

variable "name_prefix" {
  description = "Short lowercase resource name prefix."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
  type        = string
}

variable "grafana_database_password" {
  description = "Password for the Grafana Cloud SQL database user."
  type        = string
  sensitive   = true
}

variable "grafana_database_tier" {
  description = "Cloud SQL machine tier used for Grafana persistence."
  type        = string
}

variable "grafana_admin_password" {
  description = "Grafana administrator password, stored in Secret Manager."
  type        = string
  sensitive   = true
}

variable "grafana_invoker_members" {
  description = "IAM members permitted to invoke the private Grafana service."
  type        = list(string)
}

variable "deletion_protection" {
  description = "Enable Cloud SQL deletion protection for this environment."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Resource labels."
  type        = map(string)
  default     = {}
}
