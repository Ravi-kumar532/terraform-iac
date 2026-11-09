variable "name" {
  type        = string
  description = "Elastic Beanstalk application name; this module provisions the native application, version, and web environment."
}
variable "tags" {
  type = map(string)
  default = {

  }
  description = "Resource tags."
}
variable "description" {
  type        = string
  default     = ""
  description = "Application description."
}
variable "environment_name" {
  type        = string
  description = "Primary Elastic Beanstalk environment name."
}
variable "environment_names" {
  type        = list(string)
  default     = []
  description = "Additional Elastic Beanstalk environment names, all using the shared application version and environment settings."
}
variable "solution_stack_name" {
  type        = string
  description = "AWS-supported solution stack name for the application runtime."
}
variable "service_role_arn" {
  type        = string
  description = "Caller-provided Elastic Beanstalk service role ARN."
}
variable "instance_profile_name" {
  type        = string
  description = "Caller-provided EC2 instance profile name with least-privilege permissions."
}
variable "min_instances" {
  type        = number
  default     = 2
  description = "Minimum EC2 instances behind the load balancer."
}
variable "max_instances" {
  type        = number
  default     = 6
  description = "Maximum EC2 instances."
}

variable "version_label" {
  type        = string
  description = "Immutable application version label."

}
variable "source_bucket" {
  type        = string
  description = "Private S3 source bundle bucket."

}
variable "source_key" {
  type        = string
  description = "Source bundle object key."

}

variable "load_balancer_scheme" {
  type        = string
  default     = "internal"
  description = "Load balancer scheme; use internet-facing only when explicitly required."

}
variable "certificate_arn" {
  type        = string
  description = "ACM certificate ARN for the HTTPS listener."

}
