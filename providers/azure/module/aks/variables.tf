variable "name" {
  type        = string
  description = "Resource name; supply a globally unique name where the Azure service requires one."
}
variable "resource_group_name" {
  type        = string
  description = "Existing resource group name."
}
variable "location" {
  type        = string
  description = "Azure region for the resource."
}
variable "tags" {
  type = map(string)
  default = {

  }
  description = "Resource tags."
}
variable "dns_prefix" {
  type        = string
  description = "AKS cluster DNS prefix; the module provisions the native azurerm_kubernetes_cluster."
}
variable "kubernetes_version" {
  type        = string
  default     = null
  description = "Optional supported Kubernetes version; null selects the current default."
}
variable "private_cluster_enabled" {
  type        = bool
  default     = true
  description = "Use a private control plane by default; configure private DNS and network access externally."
}
variable "automatic_upgrade_channel" {
  type        = string
  default     = "patch"
  description = "Automatic Kubernetes upgrade channel."
}
variable "sku_tier" {
  type        = string
  default     = "Standard"
  description = "AKS tier."
}
variable "node_vm_size" {
  type        = string
  default     = "Standard_D4s_v5"
  description = "System node VM size."
}
variable "node_count" {
  type        = number
  default     = 3
  description = "Initial system node count."
}
variable "min_count" {
  type        = number
  default     = 3
  description = "Autoscaling minimum system nodes."
}
variable "max_count" {
  type        = number
  default     = 10
  description = "Autoscaling maximum system nodes."
}
variable "subnet_id" {
  type        = string
  default     = null
  description = "Optional existing subnet ID for cluster nodes."
}
