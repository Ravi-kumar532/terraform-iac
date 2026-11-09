variable "project_id" {
  type        = string
  description = "Existing Google Cloud project ID."
}
variable "name" {
  type        = string
  description = "Google Cloud VPC network name for the native google_compute_network; subnets are managed separately."
}
