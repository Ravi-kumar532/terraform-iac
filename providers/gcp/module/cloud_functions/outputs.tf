output "id" {
  value = google_cloudfunctions2_function.this.id
}
output "name" {
  value = google_cloudfunctions2_function.this.name
}
output "uri" {
  value = google_cloudfunctions2_function.this.service_config[0].uri
}
