variable "name" {
  type        = string
  description = "Azure SQL Database name for the native azurerm_mssql_database."
}
variable "server_id" {
  type        = string
  description = "Existing Azure SQL server ID."
}
variable "sku_name" {
  type        = string
  default     = "GP_S_Gen5_2"
  description = "Production-capable SQL database SKU."
}
variable "zone_redundant" {
  type        = bool
  default     = true
  description = "Enable zone redundancy where supported by the selected SKU and region."
}
variable "storage_account_type" {
  type        = string
  default     = "Geo"
  description = "Backup storage redundancy."
}
variable "min_capacity" {
  type        = number
  default     = 0.5
  description = "Serverless minimum vCore capacity; use a compatible SKU."
}
variable "backup_retention_days" {
  type        = number
  default     = 35
  description = "Point-in-time restore retention in days."
}

variable "tags" {
  type = map(string)
  default = {

  }
  description = "Resource tags."

}

variable "prevent_destroy" {
  description = "Prevent accidental database deletion; set false only through a reviewed decommission plan."
  type        = bool
  default     = true
}
