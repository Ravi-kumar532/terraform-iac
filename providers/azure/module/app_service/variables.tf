variable "name" {
  type        = string
  description = "Azure App Service Plan name for the native azurerm_service_plan."
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
variable "os_type" {
  type        = string
  default     = "Linux"
  description = "App Service operating system."
}
variable "sku_name" {
  type        = string
  default     = "P1v3"
  description = "Plan SKU; production workloads should use an appropriate paid tier."
}
