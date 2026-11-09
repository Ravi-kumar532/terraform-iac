variable "name" {
  type        = string
  description = "Azure Container Registry name for the native azurerm_container_registry."

}
variable "resource_group_name" {
  type        = string
  description = "Existing resource group name."

}
variable "location" {
  type        = string
  description = "Azure region."

}
variable "sku" {
  type        = string
  default     = "Premium"
  description = "Registry SKU; Premium supports private endpoints and geo-replication."

}
variable "public_network_access_enabled" {
  type        = bool
  default     = false
  description = "Enable public registry access intentionally; private endpoint and DNS are caller-managed."

}
variable "tags" {
  type = map(string)
  default = {

  }
  description = "Resource tags."

}
