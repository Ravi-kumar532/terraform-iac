variable "name" {
  type        = string
  description = "Azure Event Grid topic name for the native azurerm_eventgrid_topic."

  validation {
    condition     = length(trimspace(var.name)) > 0
    error_message = "The Event Grid topic name must not be empty."
  }
}
variable "resource_group_name" {
  type        = string
  description = "Existing resource group name."

  validation {
    condition     = length(trimspace(var.resource_group_name)) > 0
    error_message = "The resource group name must not be empty."
  }
}
variable "location" {
  type        = string
  description = "Azure region."

  validation {
    condition     = length(trimspace(var.location)) > 0
    error_message = "The Azure location must not be empty."
  }
}
variable "public_network_access_enabled" {
  type        = bool
  default     = false
  description = "Enable public event publishing intentionally; private endpoint and DNS configuration are caller-managed."

}
variable "tags" {
  type        = map(string)
  default     = {}
  description = "Resource tags."
}
variable "publisher_principal_ids" {
  type        = set(string)
  default     = []
  description = "Managed identity principal IDs granted the EventGrid Data Sender role on this topic."

  validation {
    condition     = alltrue([for principal_id in var.publisher_principal_ids : length(trimspace(principal_id)) > 0])
    error_message = "Publisher principal IDs must not be empty."
  }
}
