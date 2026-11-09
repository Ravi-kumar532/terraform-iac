locals {
  name = "${var.name_prefix}-${var.environment}"
}

resource "google_project_service" "monitoring" {
  project            = var.project_id
  service            = "monitoring.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "run" {
  project            = var.project_id
  service            = "run.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "sql" {
  project            = var.project_id
  service            = "sqladmin.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "secret_manager" {
  project            = var.project_id
  service            = "secretmanager.googleapis.com"
  disable_on_destroy = false
}

resource "google_sql_database_instance" "grafana" {
  project             = var.project_id
  name                = "${local.name}-grafana"
  region              = var.region
  database_version    = "MYSQL_8_0"
  deletion_protection = var.deletion_protection

  settings {
    tier              = var.grafana_database_tier
    availability_type = var.environment == "prod" ? "REGIONAL" : "ZONAL"
    disk_type         = "PD_SSD"
    disk_size         = 20
    disk_autoresize   = true

    backup_configuration {
      enabled                        = true
      point_in_time_recovery_enabled = true
      transaction_log_retention_days = 7
      backup_retention_settings {
        retained_backups = var.environment == "prod" ? 30 : 7
      }
    }
  }

  depends_on = [google_project_service.sql]
}

resource "google_sql_database" "grafana" {
  project  = var.project_id
  name     = "grafana"
  instance = google_sql_database_instance.grafana.name
}

resource "google_sql_user" "grafana" {
  project  = var.project_id
  name     = "grafana"
  instance = google_sql_database_instance.grafana.name
  password = var.grafana_database_password
}

resource "google_secret_manager_secret" "grafana_admin" {
  project   = var.project_id
  secret_id = "${local.name}-grafana-admin"

  replication {
    auto {}
  }

  depends_on = [google_project_service.secret_manager]
}

resource "google_secret_manager_secret_version" "grafana_admin" {
  secret      = google_secret_manager_secret.grafana_admin.id
  secret_data = var.grafana_admin_password
}

resource "google_secret_manager_secret" "grafana_database" {
  project   = var.project_id
  secret_id = "${local.name}-grafana-database"

  replication {
    auto {}
  }

  depends_on = [google_project_service.secret_manager]
}

resource "google_secret_manager_secret_version" "grafana_database" {
  secret      = google_secret_manager_secret.grafana_database.id
  secret_data = var.grafana_database_password
}

resource "google_secret_manager_secret" "grafana_datasource" {
  project   = var.project_id
  secret_id = "${local.name}-grafana-datasource"

  replication {
    auto {}
  }

  depends_on = [google_project_service.secret_manager]
}

resource "google_secret_manager_secret_version" "grafana_datasource" {
  secret = google_secret_manager_secret.grafana_datasource.id
  secret_data = yamlencode({
    apiVersion = 1
    datasources = [{
      name      = "Google Cloud Monitoring"
      type      = "stackdriver"
      access    = "proxy"
      isDefault = true
      jsonData = {
        authenticationType = "gce"
        defaultProject     = var.project_id
      }
    }]
  })
}

resource "google_service_account" "grafana" {
  project      = var.project_id
  account_id   = "${var.name_prefix}-${var.environment}-grafana"
  display_name = "Grafana runtime for ${var.environment}"
}

resource "google_project_iam_member" "monitoring_viewer" {
  project = var.project_id
  role    = "roles/monitoring.viewer"
  member  = "serviceAccount:${google_service_account.grafana.email}"
}

resource "google_project_iam_member" "cloud_sql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.grafana.email}"
}

resource "google_secret_manager_secret_iam_member" "grafana_admin" {
  project   = var.project_id
  secret_id = google_secret_manager_secret.grafana_admin.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.grafana.email}"
}

resource "google_secret_manager_secret_iam_member" "grafana_database" {
  project   = var.project_id
  secret_id = google_secret_manager_secret.grafana_database.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.grafana.email}"
}

resource "google_secret_manager_secret_iam_member" "grafana_datasource" {
  project   = var.project_id
  secret_id = google_secret_manager_secret.grafana_datasource.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.grafana.email}"
}

resource "google_cloud_run_v2_service" "grafana" {
  project             = var.project_id
  name                = "${local.name}-grafana"
  location            = var.region
  ingress             = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"
  deletion_protection = var.deletion_protection

  template {
    service_account = google_service_account.grafana.email
    scaling {
      min_instance_count = var.environment == "prod" ? 2 : 0
      max_instance_count = 5
    }

    volumes {
      name = "cloudsql"
      cloud_sql_instance {
        instances = [google_sql_database_instance.grafana.connection_name]
      }
    }

    volumes {
      name = "grafana-datasources"
      secret {
        secret = google_secret_manager_secret.grafana_datasource.secret_id
        items {
          version = google_secret_manager_secret_version.grafana_datasource.version
          path    = "datasources.yaml"
        }
      }
    }

    containers {
      image = "grafana/grafana:11.5.2"

      ports {
        container_port = 3000
      }

      env {
        name  = "GF_DATABASE_TYPE"
        value = "mysql"
      }
      env {
        name  = "GF_DATABASE_HOST"
        value = "/cloudsql/${google_sql_database_instance.grafana.connection_name}"
      }
      env {
        name  = "GF_DATABASE_NAME"
        value = google_sql_database.grafana.name
      }
      env {
        name  = "GF_DATABASE_USER"
        value = google_sql_user.grafana.name
      }
      env {
        name = "GF_DATABASE_PASSWORD"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.grafana_database.secret_id
            version = google_secret_manager_secret_version.grafana_database.version
          }
        }
      }
      env {
        name = "GF_SECURITY_ADMIN_PASSWORD"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.grafana_admin.secret_id
            version = google_secret_manager_secret_version.grafana_admin.version
          }
        }
      }
      env {
        name  = "GF_AUTH_ANONYMOUS_ENABLED"
        value = "false"
      }
      volume_mounts {
        name       = "cloudsql"
        mount_path = "/cloudsql"
      }
      volume_mounts {
        name       = "grafana-datasources"
        mount_path = "/etc/grafana/provisioning/datasources"
      }
    }
  }

  depends_on = [
    google_project_service.run,
    google_project_iam_member.monitoring_viewer,
    google_project_iam_member.cloud_sql_client,
    google_secret_manager_secret_iam_member.grafana_admin,
    google_secret_manager_secret_iam_member.grafana_database,
    google_secret_manager_secret_iam_member.grafana_datasource
  ]
}

resource "google_cloud_run_v2_service_iam_member" "invoker" {
  for_each = toset(var.grafana_invoker_members)

  project  = var.project_id
  location = google_cloud_run_v2_service.grafana.location
  name     = google_cloud_run_v2_service.grafana.name
  role     = "roles/run.invoker"
  member   = each.value
}
