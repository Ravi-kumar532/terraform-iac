resource "google_firestore_database" "this" {
  project                           = var.project_id
  name                              = var.database_name
  location_id                       = var.region
  type                              = "FIRESTORE_NATIVE"
  concurrency_mode                  = "OPTIMISTIC"
  app_engine_integration_mode       = "DISABLED"
  deletion_policy                   = "ABANDON"
  point_in_time_recovery_enablement = var.point_in_time_recovery_enablement
  delete_protection_state           = "DELETE_PROTECTION_ENABLED"
}

resource "google_firestore_document" "this" {
  for_each = var.configuration

  project     = var.project_id
  database    = google_firestore_database.this.name
  collection  = var.collection_name
  document_id = each.key
  fields = jsonencode({
    value = {
      stringValue = each.value
    }
  })
}
