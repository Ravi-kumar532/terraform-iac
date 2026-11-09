resource "azurerm_mssql_server" "this" {
  name                          = var.name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = var.sql_server_version
  administrator_login           = var.administrator_login
  administrator_login_password  = var.administrator_login_password
  minimum_tls_version           = "1.2"
  public_network_access_enabled = var.public_network_access_enabled
  azuread_administrator {
    login_username              = var.azuread_admin_login
    object_id                   = var.azuread_admin_object_id
    tenant_id                   = var.tenant_id
    azuread_authentication_only = true
  }
  tags = var.tags
  lifecycle {
    prevent_destroy = var.prevent_destroy
  }
}
