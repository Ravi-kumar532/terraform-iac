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
