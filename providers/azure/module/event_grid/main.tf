resource "azurerm_eventgrid_topic" "this" {
  name                          = var.name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  input_schema                  = "EventGridSchema"
  public_network_access_enabled = var.public_network_access_enabled
  local_auth_enabled            = false
  tags                          = var.tags
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "publisher" {
  for_each = var.publisher_principal_ids

  scope                = azurerm_eventgrid_topic.this.id
  role_definition_name = "EventGrid Data Sender"
  principal_id         = each.value
  principal_type       = "ServicePrincipal"
}
