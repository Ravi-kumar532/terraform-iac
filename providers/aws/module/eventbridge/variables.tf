variable "name" {
  type        = string
  description = "EventBridge event bus name for the native aws_cloudwatch_event_bus."
}
variable "tags" {
  type = map(string)
  default = {

  }
  description = "Resource tags."
}
variable "kms_key_arn" {
  type        = string
  default     = null
  description = "Optional KMS key ARN for event bus encryption; null uses AWS-owned encryption."
}
