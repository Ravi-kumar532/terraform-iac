resource "azurerm_key_vault" "this" {
  name                       = var.name
  resource_group_name        = var.resource_group_name
  location                   = var.location
  tenant_id                  = var.tenant_id
  sku_name                   = var.sku_name
  rbac_authorization_enabled = false
  soft_delete_retention_days = 7
  purge_protection_enabled   = true
  tags                       = var.tags
}