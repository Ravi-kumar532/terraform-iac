output "id" {
  value = azurerm_container_registry.this.id
}
output "login_server" {
  value = azurerm_container_registry.this.login_server
}
output "identity_principal_id" {
  value = azurerm_container_registry.this.identity[0].principal_id
}
