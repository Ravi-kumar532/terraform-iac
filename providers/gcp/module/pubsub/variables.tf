variable "project_id" {
  type        = string
  description = "Existing Google Cloud project ID."
}
variable "name" {
  type        = string
  description = "Pub/Sub topic name for the native google_pubsub_topic and optional subscription."
}
variable "region" {
  type        = string
  description = "Google Cloud region."
}
variable "labels" {
  type = map(string)
  default = {

  }
  description = "Resource labels."
}
variable "kms_key_name" {
  type        = string
  default     = null
  description = "Optional CMEK key name; grant Pub/Sub service agent access."
}
variable "message_retention_duration" {
  type        = string
  default     = "1209600s"
  description = "Topic and subscription message retention period (14 days)."
}
variable "create_subscription" {
  type        = bool
  default     = true
  description = "Create a subscription alongside the topic."
}
variable "subscription_name" {
  type        = string
  default     = null
  description = "Subscription name required when create_subscription is true."
}
variable "ack_deadline_seconds" {
  type        = number
  default     = 60
  description = "Subscription acknowledgement deadline."
}
variable "dead_letter_topic" {
  type        = string
  default     = null
  description = "Optional fully qualified dead-letter topic name; configure its IAM policy externally."
}
variable "max_delivery_attempts" {
  type        = number
  default     = 5
  description = "Maximum delivery attempts before dead-lettering."
}
