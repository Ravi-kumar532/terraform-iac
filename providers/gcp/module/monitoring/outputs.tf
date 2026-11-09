output "grafana_uri" {
  description = "Private Cloud Run URI for Grafana."
  value       = google_cloud_run_v2_service.grafana.uri
}

output "grafana_sql_instance_connection_name" {
  description = "Cloud SQL connection name for Grafana persistence."
  value       = google_sql_database_instance.grafana.connection_name
}
