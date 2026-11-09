resource "azurerm_app_configuration" "this" {
  name                  = var.name
  resource_group_name   = var.resource_group_name
  location              = var.location
  sku                   = var.sku
  local_auth_enabled    = false
  public_network_access = var.public_network_access
  tags                  = var.tags
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_app_configuration_key" "this" {
  for_each = var.configuration

  configuration_store_id = azurerm_app_configuration.this.id
  key                    = each.key
  value                  = each.value
  label                  = var.label
  type                   = "kv"
}
