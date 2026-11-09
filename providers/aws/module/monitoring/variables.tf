variable "environment" {
  description = "Deployment environment."
  type        = string
}

variable "name_prefix" {
  description = "Short resource name prefix."
  type        = string
}

variable "alert_email" {
  description = "Optional email subscription for monitoring notifications."
  type        = string
  default     = ""
}

variable "db_instance_identifier" {
  description = "RDS DB instance identifier monitored by the CPU alarm."
  type        = string
}

variable "tags" {
  description = "Tags applied to monitoring resources."
  type        = map(string)
  default     = {}
}
