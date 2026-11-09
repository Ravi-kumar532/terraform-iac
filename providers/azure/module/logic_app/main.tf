resource "azurerm_logic_app_workflow" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  enabled             = true
  workflow_schema     = var.workflow_schema
  workflow_version    = var.workflow_version
  tags                = var.tags
  identity {
    type = "SystemAssigned"
  }
}
