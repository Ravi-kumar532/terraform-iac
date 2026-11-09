variable "project_id" {
  type        = string
  description = "Existing Google Cloud project ID."
}
variable "name" {
  type        = string
  description = "Google Kubernetes Engine cluster name for the native google_container_cluster and autoscaled node pool."
}
variable "region" {
  type        = string
  description = "Regional cluster region."
}
variable "network_self_link" {
  type        = string
  description = "Existing VPC self-link."
}
variable "subnetwork_self_link" {
  type        = string
  description = "Existing subnet self-link with pod and service secondary ranges."
}
variable "pods_range_name" {
  type        = string
  description = "Subnet secondary range name for pods."
}
variable "services_range_name" {
  type        = string
  description = "Subnet secondary range name for services."
}
variable "private_endpoint" {
  type        = bool
  default     = true
  description = "Use private control plane endpoint; configure private DNS and authorized access externally."
}
variable "master_ipv4_cidr" {
  type        = string
  description = "Unused, non-overlapping /28 range for private control plane."
}
variable "master_authorized_cidrs" {
  type = list(object({
    display_name = string
    cidr         = string
  }))
  default     = []
  description = "Authorized CIDRs for the control-plane endpoint."
}
variable "release_channel" {
  type        = string
  default     = "REGULAR"
  description = "GKE release channel."
}
variable "deletion_protection" {
  type        = bool
  default     = true
  description = "Prevent accidental cluster deletion."
}
variable "min_nodes" {
  type        = number
  default     = 1
  description = "Autoscaling minimum nodes per zone."
}
variable "max_nodes" {
  type        = number
  default     = 5
  description = "Autoscaling maximum nodes per zone."
}
variable "machine_type" {
  type        = string
  default     = "e2-standard-4"
  description = "Node machine type."
}
variable "node_service_account_email" {
  type        = string
  description = "Caller-provided least-privilege node service account email."
}
variable "disk_size_gb" {
  type        = number
  default     = 100
  description = "Node boot disk size."
}
variable "labels" {
  type = map(string)
  default = {

  }
  description = "Cluster labels."
}
