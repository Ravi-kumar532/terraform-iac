variable "name" {
  type        = string
  description = "Azure Storage Account name for the native azurerm_storage_account; must meet Azure naming requirements."

  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.name))
    error_message = "The storage account name must contain 3-24 lowercase letters or numbers."
  }
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
variable "account_tier" {
  type        = string
  default     = "Standard"
  description = "Storage tier."

  validation {
    condition     = contains(["Standard", "Premium"], var.account_tier)
    error_message = "The storage account tier must be Standard or Premium."
  }
}
variable "replication_type" {
  type        = string
  default     = "ZRS"
  description = "Replication strategy; select a region-supported option."

  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.replication_type)
    error_message = "Use a supported Azure Storage replication type: LRS, GRS, RAGRS, ZRS, GZRS, or RAGZRS."
  }
}
variable "public_network_access_enabled" {
  type        = bool
  default     = false
  description = "Enable public endpoint access intentionally; private endpoints and DNS are caller-managed."
}

variable "containers" {
  description = "Private blob containers keyed by stable caller-chosen identifiers."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for name in values(var.containers) :
      can(regex("^[a-z0-9][a-z0-9-]{1,61}[a-z0-9]$", name))
    ])
    error_message = "Container names must be 3-63 lowercase letters, numbers, or hyphens, and start and end with a letter or number."
  }
}

variable "blobs" {
  description = "Blob definitions keyed by stable caller-chosen identifiers; source paths are read by Terraform and no credentials are managed."
  type = map(object({
    name         = string
    container    = string
    source       = string
    content_type = optional(string)
    type         = optional(string, "Block")
  }))
  default = {}

  validation {
    condition = alltrue([
      for blob in values(var.blobs) :
      length(trimspace(blob.name)) > 0 &&
      length(trimspace(blob.container)) > 0 &&
      length(trimspace(blob.source)) > 0 &&
      contains(["Block", "Append", "Page"], blob.type)
    ])
    error_message = "Each blob must specify a name, container, source path, and a supported blob type (Block, Append, or Page)."
  }
}
