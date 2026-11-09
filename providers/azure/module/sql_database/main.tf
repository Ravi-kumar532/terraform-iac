resource "azurerm_mssql_database" "this" {
  name                                = var.name
  server_id                           = var.server_id
  tags                                = var.tags
  sku_name                            = var.sku_name
  zone_redundant                      = var.zone_redundant
  storage_account_type                = var.storage_account_type
  transparent_data_encryption_enabled = true
  min_capacity                        = var.min_capacity
  short_term_retention_policy {
    retention_days = var.backup_retention_days
  }
  lifecycle {
    prevent_destroy = var.prevent_destroy
  }
}
