resource "aws_sqs_queue" "this" {
  name                        = var.name
  fifo_queue                  = var.fifo_queue
  content_based_deduplication = var.fifo_queue
  kms_master_key_id           = var.kms_key_arn
  sqs_managed_sse_enabled     = var.kms_key_arn == null
  message_retention_seconds   = var.message_retention_seconds
  visibility_timeout_seconds  = var.visibility_timeout_seconds
  tags                        = var.tags
}

resource "aws_sns_topic" "this" {
  count = var.create_topic ? 1 : 0

  name              = coalesce(var.topic_name, "${var.name}-topic")
  kms_master_key_id = coalesce(var.kms_key_arn, "alias/aws/sns")
  tags              = var.tags
}
