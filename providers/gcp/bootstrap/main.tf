resource "google_storage_bucket" "terraform_state" {
  project                     = var.project_id
  name                        = var.state_bucket_name
  location                    = var.location
  force_destroy               = var.force_destroy
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  versioning {
    enabled = true
  }

  retention_policy {
    retention_period = 2592000
    is_locked        = false
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age              = 365
      with_state       = "ARCHIVED"
      matches_prefix   = ["env:"]
      send_age_if_zero = false
    }
  }

  labels = {
    purpose    = "terraform-state"
    managed_by = "terraform"
  }
}
