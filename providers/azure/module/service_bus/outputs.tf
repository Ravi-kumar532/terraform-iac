output "namespace_ids" {
  description = "Namespace resource IDs keyed by namespace definition key."
  value       = { for key, namespace in azurerm_servicebus_namespace.this : key => namespace.id }
}

output "namespace_endpoints" {
  description = "Namespace endpoints keyed by namespace definition key."
  value       = { for key, namespace in azurerm_servicebus_namespace.this : key => namespace.endpoint }
}

output "namespace_identity_principal_ids" {
  description = "System-assigned identity principal IDs keyed by namespace definition key."
  value       = { for key, namespace in azurerm_servicebus_namespace.this : key => namespace.identity[0].principal_id }
}

output "queue_ids" {
  description = "Queue resource IDs keyed by JSON-encoded namespace/entity definition keys."
  value       = { for key, queue in azurerm_servicebus_queue.this : key => queue.id }
}

output "topic_ids" {
  description = "Topic resource IDs keyed by JSON-encoded namespace/entity definition keys."
  value       = { for key, topic in azurerm_servicebus_topic.this : key => topic.id }
}
