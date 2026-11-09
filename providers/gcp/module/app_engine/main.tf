resource "google_app_engine_application" "this" {
  project     = var.project_id
  location_id = var.app_location
}

resource "google_app_engine_standard_app_version" "this" {
  for_each = var.versions

  project         = google_app_engine_application.this.project
  service         = each.value.service_name
  version_id      = each.value.version_id
  runtime         = each.value.runtime
  instance_class  = each.value.instance_class
  service_account = each.value.service_account
  entrypoint {
    shell = each.value.entrypoint_command
  }
  delete_service_on_destroy = false
  deployment {
    zip {
      source_url = each.value.source_archive_url
    }
  }
  env_variables = each.value.environment_variables
  handlers {
    url_regex = "/.*"
    script {
      script_path = "auto"
    }
    security_level = "SECURE_ALWAYS"
    login          = "LOGIN_REQUIRED"
  }
  automatic_scaling {
    standard_scheduler_settings {
      min_instances = each.value.min_instances
      max_instances = each.value.max_instances
    }
  }
  noop_on_destroy = true
}
