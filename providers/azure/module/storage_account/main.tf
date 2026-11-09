resource "azurerm_storage_account" "this" {

  name                            = var.name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = var.account_tier
  account_replication_type        = var.replication_type
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  public_network_access_enabled   = var.public_network_access_enabled
  https_traffic_only_enabled      = true
  tags                            = var.tags
  blob_properties {
    versioning_enabled = true
    delete_retention_policy {
      days = 7
    }
    container_delete_retention_policy {
      days = 7
    }
  }
  identity {
    type = "SystemAssigned"
  }

}

resource "azurerm_storage_container" "this" {
  for_each = var.containers

  name                  = each.value
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = "private"
}

resource "azurerm_storage_blob" "this" {
  for_each = var.blobs

  name                   = each.value.name
  storage_account_name   = azurerm_storage_account.this.name
  storage_container_name = each.value.container
  type                   = each.value.type
  source                 = each.value.source
  content_type           = each.value.content_type

  depends_on = [azurerm_storage_container.this]
}
