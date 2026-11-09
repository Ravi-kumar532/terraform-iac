variable "project_id" {
  type        = string
  description = "Existing Google Cloud project ID."
}
variable "name" {
  type        = string
  description = "Cloud SQL instance name for the native google_sql_database_instance."
}
variable "region" {
  type        = string
  description = "Instance region."
}
variable "database_version" {
  type        = string
  default     = "POSTGRES_16"
  description = "Supported database version."
}
variable "tier" {
  type        = string
  default     = "db-custom-2-7680"
  description = "Instance machine tier."
}
variable "availability_type" {
  type        = string
  default     = "REGIONAL"
  description = "REGIONAL for HA or ZONAL where appropriate."
}
variable "disk_size_gb" {
  type        = number
  default     = 100
  description = "Initial SSD size; automatic growth is enabled."
}
variable "backup_retention_count" {
  type        = number
  default     = 14
  description = "Automated backup retention count."
}
variable "public_ipv4_enabled" {
  type        = bool
  default     = false
  description = "Enable public IPv4 intentionally; authorized networks are caller-managed."
}
variable "private_network_self_link" {
  type        = string
  default     = null
  description = "Existing VPC self-link for private IP; required for private connectivity."
}
variable "deletion_protection" {
  type        = bool
  default     = true
  description = "Prevent accidental instance deletion."
}

variable "labels" {
  type = map(string)
  default = {

  }
  description = "Cloud SQL user labels."

}
