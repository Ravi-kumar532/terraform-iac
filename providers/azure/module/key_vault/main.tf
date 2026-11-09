resource "azurerm_key_vault" "this" {
  name                          = var.name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  tenant_id                     = var.tenant_id
  sku_name                      = var.sku_name
  rbac_authorization_enabled    = var.rbac_authorization_enabled
  soft_delete_retention_days    = var.soft_delete_retention_days
  purge_protection_enabled      = true
  public_network_access_enabled = var.public_network_access_enabled
  tags                          = var.tags
}


# Use RBAC for modern deployments; legacy access policies are only enabled
# when the caller explicitly disables RBAC on the vault.
resource "azurerm_key_vault_access_policy" "this" {
  for_each = var.rbac_authorization_enabled ? {} : var.access_policies

  key_vault_id           = azurerm_key_vault.this.id
  tenant_id              = each.value.tenant_id
  object_id              = each.value.object_id
  secret_permissions     = each.value.secret_permissions
  key_permissions        = each.value.key_permissions
  certificate_permissions = each.value.certificate_permissions
  storage_permissions   = each.value.storage_permissions
}

resource "azurerm_role_assignment" "this" {
  for_each = var.rbac_authorization_enabled ? var.role_assignments : {}

  scope                            = azurerm_key_vault.this.id
  role_definition_name             = each.value.role_definition_name
  principal_id                     = each.value.principal_id
  description                      = each.value.description
  principal_type                   = each.value.principal_type
  skip_service_principal_aad_check = each.value.skip_service_principal_aad_check
}
