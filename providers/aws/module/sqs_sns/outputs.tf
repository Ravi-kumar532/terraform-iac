output "id" {
  value = aws_sqs_queue.this.id
}
output "arn" {
  value = aws_sqs_queue.this.arn
}
output "url" {
  value = aws_sqs_queue.this.url
}
output "topic_arn" {
  value = try(aws_sns_topic.this[0].arn, null)
}
