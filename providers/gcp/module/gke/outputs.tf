output "id" {
  value = google_container_cluster.this.id
}
output "endpoint" {
  value     = google_container_cluster.this.endpoint
  sensitive = true
}
output "node_pool_id" {
  value = google_container_node_pool.this.id
}
