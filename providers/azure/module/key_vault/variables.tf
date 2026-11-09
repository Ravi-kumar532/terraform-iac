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

variable "rbac_authorization_enabled" {
  description = "Use Azure RBAC for data-plane authorization. Recommended for production."
  type        = bool
  default     = true
}

variable "public_network_access_enabled" {
  description = "Allow public endpoint access. Keep disabled when a private endpoint and private DNS path are provisioned."
  type        = bool
  default     = false
}

variable "soft_delete_retention_days" {
  description = "Soft-delete retention period in days."
  type        = number
  default     = 90
  validation {
    condition     = var.soft_delete_retention_days >= 7 && var.soft_delete_retention_days <= 90
    error_message = "Key Vault soft-delete retention must be between 7 and 90 days."
  }
}

variable "access_policies" {
  description = "Legacy access policies, used only when RBAC authorization is disabled."
  type = map(object({
    tenant_id               = string
    object_id               = string
    secret_permissions      = optional(list(string), ["Get", "List"])
    key_permissions         = optional(list(string), [])
    certificate_permissions = optional(list(string), [])
    storage_permissions     = optional(list(string), [])
  }))
  default = {}
}

variable "role_assignments" {
  description = "Azure RBAC role assignments keyed by stable caller-chosen identifiers."
  type = map(object({
    principal_id         = string
    role_definition_name = string
    description          = optional(string)
    principal_type       = optional(string)
    skip_service_principal_aad_check = optional(bool, false)
  }))
  default = {}
  validation {
    condition = alltrue([
      for assignment in values(var.role_assignments) :
      length(trimspace(assignment.principal_id)) > 0 &&
      length(trimspace(assignment.role_definition_name)) > 0
    ])
    error_message = "Each role assignment requires a principal ID and role definition name."
  }
}

variable "tags" {
  description = "Tags to apply to the Key Vault."
  type        = map(string)
  default     = {}
}
