variable "name" {
  description = "Monitoring resource name."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group for monitoring resources."
  type        = string
}

variable "location" {
  description = "Azure region for monitoring resources."
  type        = string
}

variable "aks_cluster_id" {
  description = "Resource ID of the AKS cluster to collect Prometheus metrics from."
  type        = string
}

variable "tags" {
  description = "Tags applied to monitoring resources."
  type        = map(string)
  default     = {}
}
