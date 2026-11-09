resource "google_sql_database_instance" "this" {

  project             = var.project_id
  name                = var.name
  region              = var.region
  database_version    = var.database_version
  deletion_protection = var.deletion_protection

  settings {

    tier              = var.tier
    availability_type = var.availability_type
    disk_type         = "PD_SSD"
    disk_size         = var.disk_size_gb
    disk_autoresize   = true
    user_labels       = var.labels

    backup_configuration {

      enabled                        = true
      point_in_time_recovery_enabled = true
      transaction_log_retention_days = 7

      backup_retention_settings {

        retained_backups = var.backup_retention_count
        retention_unit   = "COUNT"

      }

    }

    ip_configuration {

      ipv4_enabled    = var.public_ipv4_enabled
      private_network = var.private_network_self_link
      ssl_mode        = "ENCRYPTED_ONLY"

    }

  }

  lifecycle {

    precondition {

      condition     = var.public_ipv4_enabled || var.private_network_self_link != null
      error_message = "Set private_network_self_link when public_ipv4_enabled is false."

    }

  }

}
