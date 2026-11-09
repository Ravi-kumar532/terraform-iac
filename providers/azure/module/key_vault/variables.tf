variable "name" {
  description = "Globally unique name of the Key Vault."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9][A-Za-z0-9-]{1,22}[A-Za-z0-9]$", var.name))
    error_message = "The Key Vault name must be 3-24 characters, start and end with a letter or number, and contain only letters, numbers, and hyphens."
  }
}

variable "resource_group_name" {
  description = "Name of the resource group containing the Key Vault."
  type        = string
}

variable "location" {
  description = "Azure region in which to create the Key Vault."
  type        = string
}

variable "tenant_id" {
  description = "Microsoft Entra tenant ID for the Key Vault."
  type        = string
}

variable "sku_name" {
  description = "Key Vault SKU."
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["standard", "premium"], var.sku_name)
    error_message = "The Key Vault SKU must be standard or premium."
  }
}

variable "access_policies" {
  description = "Access policies keyed by stable caller-chosen principal identifiers; grant only required permissions."
  type = map(object({
    tenant_id               = string
    object_id               = string
    secret_permissions      = optional(list(string), ["Get", "List"])
    key_permissions         = optional(list(string), [])
    certificate_permissions = optional(list(string), [])
    storage_permissions     = optional(list(string), [])
  }))
  default = {}

  validation {
    condition = alltrue([
      for policy in values(var.access_policies) :
      length(trimspace(policy.tenant_id)) > 0 &&
      length(trimspace(policy.object_id)) > 0
    ])
    error_message = "Each access policy must specify a non-empty tenant ID and principal object ID."
  }
}

variable "tags" {
  description = "Tags to apply to the Key Vault."
  type        = map(string)
  default     = {}
}