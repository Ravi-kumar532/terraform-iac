variable "name" {
  type        = string
  description = "Lambda function name for the native aws_lambda_function."
}
variable "tags" {
  type = map(string)
  default = {

  }
  description = "Resource tags."
}
variable "execution_role_arn" {
  type        = string
  description = "Caller-provided Lambda execution role ARN; grant only required permissions."
}
variable "runtime" {
  type        = string
  default     = "python3.12"
  description = "Supported Lambda runtime."
}
variable "handler" {
  type        = string
  description = "Function handler entry point."
}
variable "package_bucket" {
  type        = string
  description = "Existing private S3 bucket containing the deployment package."
}
variable "package_key" {
  type        = string
  description = "S3 object key for the deployment package."
}
variable "timeout" {
  type        = number
  default     = 30
  description = "Maximum execution time in seconds."
}
variable "memory_size" {
  type        = number
  default     = 512
  description = "Memory allocation in MB."
}
variable "reserved_concurrency" {
  type        = number
  default     = 20
  description = "Reserved concurrency limit to prevent unbounded scaling."
}
variable "kms_key_arn" {
  type        = string
  default     = null
  description = "Optional KMS key ARN for environment variable encryption."
}
variable "environment_variables" {
  type = map(string)
  default = {

  }
  description = "Non-secret environment variables only; inject secrets at runtime from a secret manager."
}
