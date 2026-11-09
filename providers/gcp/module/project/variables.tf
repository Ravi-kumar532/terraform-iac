variable "project_id" {
  type        = string
  description = "Google Cloud project ID for the native google_project or existing google_project data source; creation requires organization/folder and billing inputs."
}
variable "create_project" {
  type        = bool
  default     = false
  description = "Create project explicitly; requires organization_id or folder_id and billing_account."
}
variable "display_name" {
  type        = string
  default     = null
  description = "Display name required when create_project is true."
}
variable "organization_id" {
  type        = string
  default     = null
  description = "Organization ID required to create a project unless folder_id is set."
}
variable "folder_id" {
  type        = string
  default     = null
  description = "Optional folder ID for project creation."
}
variable "billing_account" {
  type        = string
  default     = null
  description = "Billing account required to create a project."
}
variable "labels" {
  type = map(string)
  default = {

  }
  description = "Project labels."
}
