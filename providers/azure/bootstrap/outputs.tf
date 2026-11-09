output "resource_group_name" {
  description = "Resource group containing Terraform state."
  value       = azurerm_resource_group.terraform_state.name
}

output "storage_account_name" {
  description = "Storage account containing Terraform state."
  value       = azurerm_storage_account.terraform_state.name
}

output "container_name" {
  description = "Private blob container for Terraform state."
  value       = azurerm_storage_container.terraform_state.name
}

output "state_resource_group_name" {
  description = "Resource group containing the Terraform state account."
  value       = azurerm_resource_group.terraform_state.name
}

output "state_storage_account_name" {
  description = "Storage account name for the AzureRM backend."
  value       = azurerm_storage_account.terraform_state.name
}

output "state_container_name" {
  description = "Private container used for Terraform state."
  value       = azurerm_storage_container.terraform_state.name
}

output "state_storage_account_id" {
  description = "Storage account resource ID for RBAC assignments and private endpoints."
  value       = azurerm_storage_account.terraform_state.id
}
