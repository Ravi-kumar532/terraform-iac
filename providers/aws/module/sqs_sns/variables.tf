variable "name" {
  type        = string
  description = "Amazon SQS queue name for the native aws_sqs_queue."
}
variable "tags" {
  type = map(string)
  default = {

  }
  description = "Resource tags."
}
variable "fifo_queue" {
  type        = bool
  default     = false
  description = "Create a FIFO queue when true; the name must end with .fifo."
}
variable "kms_key_arn" {
  type        = string
  default     = null
  description = "Optional customer-managed KMS key ARN; otherwise SQS-managed encryption is enabled."
}
variable "message_retention_seconds" {
  type        = number
  default     = 1209600
  description = "Message retention period (14 days by default)."
}
variable "visibility_timeout_seconds" {
  type        = number
  default     = 60
  description = "Message visibility timeout."
}
variable "create_topic" {
  type        = bool
  default     = true
  description = "Create an encrypted SNS topic alongside the SQS queue."
}
variable "topic_name" {
  type        = string
  default     = null
  description = "Optional SNS topic name; defaults to the queue name with a -topic suffix."
}
