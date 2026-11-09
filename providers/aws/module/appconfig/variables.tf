variable "name" {
  type        = string
  description = "AWS AppConfig application name for the native aws_appconfig_application and environment."
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
  description = "Application configuration description."
}

variable "environment_name" {
  type        = string
  description = "AppConfig environment name."
}
variable "environment_description" {
  type        = string
  default     = ""
  description = "AppConfig environment description."
}
variable "configuration_profile_name" {
  type        = string
  description = "Hosted configuration profile name."
}
variable "configuration" {
  type        = map(string)
  default     = {}
  description = "Non-secret application settings deployed as JSON through AWS AppConfig."
}
variable "deployment_strategy_name" {
  type        = string
  default     = "linear-rollout"
  description = "Name of the gradual AppConfig deployment strategy."
}
variable "deployment_duration_in_minutes" {
  type        = number
  default     = 30
  description = "Time for a linear deployment rollout."
}
variable "deployment_growth_factor" {
  type        = number
  default     = 20
  description = "Percentage of targets receiving each rollout step."
}
variable "final_bake_time_in_minutes" {
  type        = number
  default     = 10
  description = "Observation time after rollout reaches all targets."
}
