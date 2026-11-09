output "id" {
  description = "Private endpoint resource ID."
  value       = azurerm_private_endpoint.this.id
}

output "network_interface_id" {
  description = "Network interface created for the private endpoint."
  value       = azurerm_private_endpoint.this.network_interface[0].id
}
