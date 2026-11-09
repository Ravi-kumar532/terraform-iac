variable "name" {
  type        = string
  description = "Azure Subnet name for the native azurerm_subnet resource."
}
variable "resource_group_name" {
  type        = string
  description = "Existing resource group name."
}
variable "virtual_network_name" {
  type        = string
  description = "Existing virtual network name."
}
variable "address_prefixes" {
  type        = list(string)
  description = "Subnet CIDR ranges."
}
variable "service_endpoints" {
  type        = list(string)
  default     = []
  description = "Azure service endpoints to enable."
}
