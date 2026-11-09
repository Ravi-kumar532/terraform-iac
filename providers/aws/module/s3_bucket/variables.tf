variable "name" {
  type        = string
  description = "S3 bucket name for the native aws_s3_bucket and its versioning, encryption, and public-access-block controls."
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
  description = "Optional customer-managed KMS key ARN; null uses the AWS-managed S3 key."
}
