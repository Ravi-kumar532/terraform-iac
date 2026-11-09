variable "resource_group_name" {
  description = "Resource group name for remote Terraform state."
  type        = string
}

variable "location" {
  description = "Azure region for remote Terraform state."
  type        = string
}

variable "storage_account_name" {
  description = "Globally unique lowercase storage account name (3-24 alphanumeric characters)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.storage_account_name))
    error_message = "storage_account_name must be 3-24 lowercase letters or numbers."
  }
}

variable "container_name" {
  description = "Blob container name for Terraform state."
  type        = string
  default     = "tfstate"
}

variable "tags" {
  description = "Tags applied to bootstrap resources."
  type        = map(string)
  default     = {}
}

variable "public_network_access_enabled" {
  description = "Allow public network access to the state storage account. Production should use private connectivity and a self-hosted runner."
  type        = bool
  default     = false
}

variable "allowed_ip_ranges" {
  description = "Explicit public IPv4 ranges allowed to reach the state storage account when public access is enabled."
  type        = list(string)
  default     = []
}

variable "allowed_subnet_ids" {
  description = "Subnet resource IDs allowed to reach the state storage account."
  type        = list(string)
  default     = []
}

variable "network_bypass" {
  description = "Azure Storage network-rule bypass services."
  type        = set(string)
  default     = []
}
