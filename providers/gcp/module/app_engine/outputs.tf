output "application_id" {
  value = google_app_engine_application.this.id
}

output "version_ids" {
  value = {
    for key, version in google_app_engine_standard_app_version.this :
    key => version.version_id
  }
}

output "services" {
  value = {
    for key, version in google_app_engine_standard_app_version.this :
    key => version.service
  }
}
