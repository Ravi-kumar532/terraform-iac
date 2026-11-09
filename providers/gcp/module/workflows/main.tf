resource "google_workflows_workflow" "this" {
  project         = var.project_id
  name            = var.name
  region          = var.region
  description     = var.description
  service_account = var.service_account_email
  source_contents = var.source_contents
  labels          = var.labels
}
