variable "name" {
  type        = string
  description = "Azure Resource Group name for the native azurerm_resource_group."

}
variable "location" {
  type        = string
  description = "Azure region."

}
variable "tags" {
  type = map(string)
  default = {

  }
  description = "Resource tags."

}
