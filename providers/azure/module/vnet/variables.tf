variable "name" {
  type        = string
  description = "Azure Virtual Network name for the native azurerm_virtual_network; subnets are managed separately."
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
variable "address_space" {
  type        = list(string)
  description = "Non-overlapping IPv4 CIDR ranges for the virtual network."
}
