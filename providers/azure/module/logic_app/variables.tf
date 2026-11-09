variable "name" {
  type        = string
  description = "Azure Logic App workflow name for the native azurerm_logic_app_workflow."
}
variable "resource_group_name" {
  type        = string
  description = "Existing resource group name."
}
variable "location" {
  type        = string
  description = "Azure region for the resource."
}
variable "tags" {
  type = map(string)
  default = {

  }
  description = "Resource tags."
}
variable "workflow_schema" {
  type        = string
  description = "Workflow definition schema JSON. Keep credentials in managed connections or Key Vault, not inline."
}
variable "workflow_version" {
  type        = string
  default     = "1.0.0.0"
  description = "Workflow definition version."
}
