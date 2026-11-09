output "id" {
  description = "Storage account resource ID."
  value       = azurerm_storage_account.this.id
}
output "name" {
  description = "Storage account name."
  value       = azurerm_storage_account.this.name
}
output "primary_blob_endpoint" {
  description = "Primary blob endpoint URL."
  value       = azurerm_storage_account.this.primary_blob_endpoint
}
output "identity_principal_id" {
  description = "System-assigned identity principal ID."
  value       = azurerm_storage_account.this.identity[0].principal_id
}

output "container_ids" {
  description = "Storage container IDs keyed by container definition key."
  value       = { for key, container in azurerm_storage_container.this : key => container.id }
}

output "blob_ids" {
  description = "Storage blob IDs keyed by blob definition key."
  value       = { for key, blob in azurerm_storage_blob.this : key => blob.id }
}
