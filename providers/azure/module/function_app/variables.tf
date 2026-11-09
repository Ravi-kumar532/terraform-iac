variable "name" {
  type        = string
  description = "Azure Function App name for the native azurerm_linux_function_app."
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
variable "service_plan_id" {
  type        = string
  description = "Existing compatible Linux Elastic Premium or Dedicated plan ID."
}
variable "storage_account_name" {
  type        = string
  description = "Existing storage account name; grant the function identity required data-plane roles."
}
variable "python_version" {
  type        = string
  default     = "3.11"
  description = "Functions Python runtime version."
}
variable "integration_subnet_id" {
  type        = string
  default     = null
  description = "Optional VNet integration subnet ID."
}
variable "public_network_access_enabled" {
  type        = bool
  default     = false
  description = "Enable public ingress intentionally; private DNS and endpoints are caller-managed."
}
