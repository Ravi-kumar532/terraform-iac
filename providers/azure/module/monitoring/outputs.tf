output "prometheus_workspace_id" {
  description = "Azure Monitor workspace ID."
  value       = azurerm_monitor_workspace.this.id
}

output "grafana_endpoint" {
  description = "Azure Managed Grafana endpoint."
  value       = azurerm_dashboard_grafana.this.endpoint
}
