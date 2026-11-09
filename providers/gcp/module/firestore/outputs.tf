output "id" {
  value = google_firestore_database.this.id
}
output "name" {
  value = google_firestore_database.this.name
}
output "configuration_document_ids" {
  value = keys(google_firestore_document.this)
}
