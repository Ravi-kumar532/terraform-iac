resource "google_pubsub_topic" "this" {
  project                    = var.project_id
  name                       = var.name
  kms_key_name               = var.kms_key_name
  message_retention_duration = var.message_retention_duration
  labels                     = var.labels
}
resource "google_pubsub_subscription" "this" {
  count                      = var.create_subscription ? 1 : 0
  project                    = var.project_id
  name                       = coalesce(var.subscription_name, "${var.name}-subscription")
  topic                      = google_pubsub_topic.this.id
  ack_deadline_seconds       = var.ack_deadline_seconds
  message_retention_duration = var.message_retention_duration
  retain_acked_messages      = false
  expiration_policy {
    ttl = ""
  }
  dynamic "dead_letter_policy" {
    for_each = var.dead_letter_topic == null ? [] : [var.dead_letter_topic]
    content {
      dead_letter_topic     = dead_letter_policy.value
      max_delivery_attempts = var.max_delivery_attempts
    }
  }
}
