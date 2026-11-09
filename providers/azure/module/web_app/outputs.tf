output "ids" {
  description = "Web App resource IDs keyed by app definition key."
  value       = { for key, app in azurerm_linux_web_app.this : key => app.id }
}

output "default_hostnames" {
  description = "Default hostnames keyed by app definition key."
  value       = { for key, app in azurerm_linux_web_app.this : key => app.default_hostname }
}

output "identity_principal_ids" {
  description = "System-assigned identity principal IDs keyed by app definition key."
  value       = { for key, app in azurerm_linux_web_app.this : key => app.identity[0].principal_id }
}
