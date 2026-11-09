output "topic_id" {
  value = google_pubsub_topic.this.id
}
output "subscription_id" {
  value = try(google_pubsub_subscription.this[0].id, null)
}
