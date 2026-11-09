output "id" {
  value = azurerm_app_configuration.this.id
}
output "endpoint" {
  value = azurerm_app_configuration.this.endpoint
}
output "identity_principal_id" {
  value = azurerm_app_configuration.this.identity[0].principal_id
}
