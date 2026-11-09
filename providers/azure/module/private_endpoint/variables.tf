variable "name" {
  description = "Name of the private endpoint."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group for the private endpoint."
  type        = string
}

variable "location" {
  description = "Azure region for the private endpoint."
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID dedicated to private endpoints."
  type        = string
}

variable "private_connection_resource_id" {
  description = "Resource ID of the target private-link service."
  type        = string
}

variable "subresource_names" {
  description = "Target service subresource names, such as vault, blob, or sites."
  type        = list(string)
}

variable "is_manual_connection" {
  description = "Whether the private service connection requires manual approval."
  type        = bool
  default     = false
}

variable "request_message" {
  description = "Optional request message for manual private-link approval."
  type        = string
  default     = null
}

variable "private_dns_zone_ids" {
  description = "Private DNS zone IDs to associate with the endpoint."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Resource tags."
  type        = map(string)
  default     = {}
}
