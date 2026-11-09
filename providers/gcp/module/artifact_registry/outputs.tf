output "id" {
  value = google_artifact_registry_repository.this.id
}
output "name" {
  value = google_artifact_registry_repository.this.name
}
output "repository_url" {
  value = "${var.region}-docker.pkg.dev/${var.project_id}/${var.name}"
}
