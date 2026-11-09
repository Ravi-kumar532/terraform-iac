resource "google_cloudfunctions2_function" "this" {
  project  = var.project_id
  name     = var.name
  location = var.region
  build_config {
    runtime     = var.runtime
    entry_point = var.entry_point
    source {

      storage_source {
        bucket = var.source_bucket
        object = var.source_object
      }
    }
  }
  service_config {
    max_instance_count             = var.max_instances
    min_instance_count             = var.min_instances
    available_memory               = var.memory
    timeout_seconds                = var.timeout_seconds
    service_account_email          = var.service_account_email
    ingress_settings               = var.ingress_settings
    all_traffic_on_latest_revision = true
  }
  labels = var.labels
}
