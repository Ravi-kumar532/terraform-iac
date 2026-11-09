output "id" {
  description = "Resource ID of the user-assigned managed identity."
  value       = azurerm_user_assigned_identity.this.id
}

output "principal_id" {
  description = "Microsoft Entra service principal object ID."
  value       = azurerm_user_assigned_identity.this.principal_id
}

output "client_id" {
  description = "Application/client ID of the managed identity."
  value       = azurerm_user_assigned_identity.this.client_id
}

output "tenant_id" {
  description = "Tenant ID associated with the managed identity."
  value       = azurerm_user_assigned_identity.this.tenant_id
}
