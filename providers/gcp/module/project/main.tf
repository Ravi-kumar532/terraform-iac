data "google_project" "existing" {
  count      = var.create_project ? 0 : 1
  project_id = var.project_id
}
resource "google_project" "this" {
  count           = var.create_project ? 1 : 0
  project_id      = var.project_id
  name            = var.display_name
  org_id          = var.organization_id
  folder_id       = var.folder_id
  billing_account = var.billing_account
  deletion_policy = "PREVENT"
  labels          = var.labels
  lifecycle {

    precondition {

      condition     = !var.create_project || (var.display_name != null && var.billing_account != null && ((var.organization_id != null) != (var.folder_id != null)))
      error_message = "Project creation requires display_name, billing_account, and exactly one of organization_id or folder_id."

    }

  }

}
