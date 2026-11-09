variable "name" {
  type        = string
  description = "Amazon ECR repository name for the native aws_ecr_repository."
}
variable "tags" {
  type = map(string)
  default = {

  }
  description = "Resource tags."
}
variable "kms_key_arn" {
  type        = string
  description = "Customer-managed KMS key ARN for repository encryption."
}
variable "lifecycle_policy" {
  type        = string
  default     = "{\"rules\":[{\"rulePriority\":1,\"description\":\"Retain the newest 30 images\",\"selection\":{\"tagStatus\":\"any\",\"countType\":\"imageCountMoreThan\",\"countNumber\":30},\"action\":{\"type\":\"expire\"}}]}"
  description = "Valid ECR lifecycle policy JSON."
}
