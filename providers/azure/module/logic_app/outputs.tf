output "id" {
  value = azurerm_logic_app_workflow.this.id
}
output "identity_principal_id" {
  value = azurerm_logic_app_workflow.this.identity[0].principal_id
}
