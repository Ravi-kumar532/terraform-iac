variable "name" {
  type        = string
  description = "App Runner service name for the native aws_apprunner_service."
}
variable "tags" {
  type = map(string)
  default = {

  }
  description = "Resource tags."
}
variable "image_identifier" {
  type        = string
  description = "ECR image URI; use a caller-managed, narrowly scoped access role."
}
variable "ecr_access_role_arn" {
  type        = string
  description = "Caller-provided App Runner ECR access role ARN."
}
variable "instance_role_arn" {
  type        = string
  default     = null
  description = "Optional caller-provided runtime instance role ARN; grant only required permissions."
}
variable "port" {
  type        = number
  default     = 8080
  description = "Container listening port."
}
variable "cpu" {
  type        = string
  default     = "1 vCPU"
  description = "App Runner CPU allocation."
}
variable "memory" {
  type        = string
  default     = "2 GB"
  description = "App Runner memory allocation."
}
variable "publicly_accessible" {
  type        = bool
  default     = false
  description = "Enable public ingress intentionally; private App Runner ingress requires a VPC interface endpoint configured by the caller."
}
variable "environment_variables" {
  type = map(string)
  default = {

  }
  description = "Non-secret runtime environment variables; never pass secrets here."
}

variable "max_concurrency" {
  type        = number
  default     = 100
  description = "Maximum concurrent requests per App Runner instance."

}
variable "min_instances" {
  type        = number
  default     = 1
  description = "Minimum App Runner instances."

}
variable "max_instances" {
  type        = number
  default     = 10
  description = "Maximum App Runner instances."

}
