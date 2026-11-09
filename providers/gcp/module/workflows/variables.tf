variable "project_id" {
  type        = string
  description = "Existing Google Cloud project ID."
}
variable "name" {
  type        = string
  description = "Google Cloud Workflows workflow name for the native google_workflows_workflow."
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
  description = "Workflow description."
}
variable "service_account_email" {
  type        = string
  description = "Caller-provided workflow service account with least-privilege permissions."
}
variable "source_contents" {
  type        = string
  description = "Workflow YAML source; use Secret Manager references, never embed credentials."
}
