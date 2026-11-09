resource "google_storage_bucket" "this" {
  project                     = var.project_id
  name                        = var.name
  location                    = var.region
  storage_class               = var.storage_class
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  force_destroy               = false
  labels                      = var.labels
  versioning {
    enabled = true
  }
  encryption {
    default_kms_key_name = var.kms_key_name
  }
  dynamic "retention_policy" {
    for_each = var.retention_period_seconds == null ? [] : [var.retention_period_seconds]
    content {
      retention_period = retention_policy.value
      is_locked        = false
    }
  }
}
