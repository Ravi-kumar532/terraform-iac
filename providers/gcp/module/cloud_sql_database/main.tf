resource "google_sql_database" "this" {
  project         = var.project_id
  name            = var.name
  instance        = var.instance_name
  charset         = var.charset
  collation       = var.collation
  deletion_policy = "ABANDON"
}
