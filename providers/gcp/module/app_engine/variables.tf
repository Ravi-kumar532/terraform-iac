variable "project_id" {
  type        = string
  description = "Existing Google Cloud project where the App Engine application will be initialized."
}

variable "app_location" {
  type        = string
  default     = "us-central"
  description = "Immutable App Engine application location ID; override with a supported location in the target project."
}

variable "versions" {
  type = map(object({
    service_name          = string
    version_id            = string
    runtime               = string
    entrypoint_command    = string
    service_account       = string
    source_archive_url    = string
    instance_class        = optional(string, "F2")
    environment_variables = optional(map(string), {})
    min_instances         = optional(number, 1)
    max_instances         = optional(number, 10)
  }))
  default     = {}
  description = "App Engine versions keyed by stable Terraform keys; service accounts are caller-provided, and environment variables must contain only non-secret data."
}
