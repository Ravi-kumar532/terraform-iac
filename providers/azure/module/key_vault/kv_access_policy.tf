resource "azurerm_key_vault_access_policy" "this" {
  for_each = var.rbac_authorization_enabled ? {} : var.access_policies

  key_vault_id = azurerm_key_vault.this.id
  tenant_id    = each.value.tenant_id
  object_id    = each.value.object_id

  secret_permissions      = each.value.secret_permissions
  key_permissions         = each.value.key_permissions
  certificate_permissions = each.value.certificate_permissions
  storage_permissions     = each.value.storage_permissions
}

resource "azurerm_role_assignment" "this" {
  for_each = var.rbac_authorization_enabled ? var.role_assignments : {}

  scope                            = azurerm_key_vault.this.id
  role_definition_name             = each.value.role_definition_name
  principal_id                     = each.value.principal_id
  description                      = try(each.value.description, null)
  principal_type                   = try(each.value.principal_type, null)
  skip_service_principal_aad_check = try(each.value.skip_service_principal_aad_check, false)
}
