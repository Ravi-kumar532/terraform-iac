variable "name" {
  type        = string
  description = "Resource name; supply a globally unique name where the Azure service requires one."
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
variable "sku" {
  type        = string
  default     = "standard"
  description = "Azure App Configuration store SKU; the module provisions native azurerm_app_configuration."
}
variable "public_network_access" {
  type        = string
  default     = "Disabled"
  description = "Public access mode; enable intentionally if private connectivity is unavailable."
}
variable "configuration" {
  type        = map(string)
  default     = {}
  description = "Non-secret key/value settings; values are stored in Terraform state."
}
variable "label" {
  type        = string
  default     = null
  description = "Optional label applied to each configuration key."
}
