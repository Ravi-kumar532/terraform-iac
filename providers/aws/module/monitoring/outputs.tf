output "prometheus_workspace_id" {
  description = "Amazon Managed Prometheus workspace ID."
  value       = aws_prometheus_workspace.this.id
}

output "prometheus_remote_write_url" {
  description = "Amazon Managed Prometheus remote-write URL."
  value       = "${aws_prometheus_workspace.this.prometheus_endpoint}api/v1/remote_write"
}

output "grafana_endpoint" {
  description = "Amazon Managed Grafana workspace URL."
  value       = aws_grafana_workspace.this.endpoint
}

output "alert_topic_arn" {
  description = "SNS topic ARN for monitoring alerts."
  value       = aws_sns_topic.alerts.arn
}
