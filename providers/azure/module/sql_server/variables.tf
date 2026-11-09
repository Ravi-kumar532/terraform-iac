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
variable "sql_server_version" {
  type        = string
  default     = "12.0"
  description = "Azure SQL Server engine version for the native azurerm_mssql_server."
}
variable "administrator_login" {
  type        = string
  sensitive   = true
  description = "Caller-supplied SQL administrator login; use a secret manager and avoid committing values."
}
variable "administrator_login_password" {
  type        = string
  sensitive   = true
  description = "Caller-supplied SQL administrator password; never output this value."
}
variable "azuread_admin_login" {
  type        = string
  description = "Azure AD administrator display name."
}
variable "azuread_admin_object_id" {
  type        = string
  description = "Azure AD administrator object ID."
}
variable "tenant_id" {
  type        = string
  description = "Azure AD tenant ID."
}
variable "public_network_access_enabled" {
  type        = bool
  default     = false
  description = "Enable public SQL endpoint access intentionally; firewall/private endpoint setup is caller-managed."
}

variable "prevent_destroy" {
  description = "Prevent accidental SQL server deletion; set false only through a reviewed decommission plan."
  type        = bool
  default     = true
}
