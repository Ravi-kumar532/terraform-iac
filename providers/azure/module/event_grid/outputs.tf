output "id" {
  description = "Event Grid topic resource ID."
  value       = azurerm_eventgrid_topic.this.id
}
output "endpoint" {
  description = "Event Grid topic endpoint."
  value       = azurerm_eventgrid_topic.this.endpoint
}
output "identity_principal_id" {
  description = "System-assigned identity principal ID for the topic."
  value       = azurerm_eventgrid_topic.this.identity[0].principal_id
}
output "publisher_role_assignment_ids" {
  description = "Publisher role assignment IDs keyed by managed identity principal ID."
  value       = { for principal_id, assignment in azurerm_role_assignment.publisher : principal_id => assignment.id }
}
