output "project_id" {
  value = var.project_id
}
output "project_number" {
  value = var.create_project ? google_project.this[0].number : data.google_project.existing[0].number
}
