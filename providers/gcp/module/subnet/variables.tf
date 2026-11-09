variable "project_id" {
  type        = string
  description = "Existing Google Cloud project ID."
}
variable "name" {
  type        = string
  description = "Google Cloud subnet name for the native google_compute_subnetwork."
}
variable "region" {
  type        = string
  description = "Subnet region."
}
variable "network_self_link" {
  type        = string
  description = "Existing VPC network self-link."
}
variable "ip_cidr_range" {
  type        = string
  description = "Subnet primary IPv4 CIDR range."
}
variable "purpose" {
  type        = string
  default     = null
  description = "Optional subnet purpose such as PRIVATE or REGIONAL_MANAGED_PROXY."
}
variable "secondary_ip_ranges" {
  type = list(object({
    range_name    = string
    ip_cidr_range = string
  }))
  default     = []
  description = "Optional secondary ranges for GKE pods and services."
}
