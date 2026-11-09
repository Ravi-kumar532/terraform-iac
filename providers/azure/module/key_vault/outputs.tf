output "id" {
  description = "ID of the Key Vault."
  value       = azurerm_key_vault.this.id
}

output "name" {
  description = "Name of the Key Vault."
  value       = azurerm_key_vault.this.name
}

output "vault_uri" {
  description = "URI of the Key Vault."
  value       = azurerm_key_vault.this.vault_uri
}

output "access_policy_ids" {
  description = "Access policy IDs keyed by access policy definition key."
  value       = { for key, policy in azurerm_key_vault_access_policy.this : key => policy.id }
}