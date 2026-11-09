resource "azurerm_kubernetes_cluster" "this" {

  name                      = var.name
  location                  = var.location
  resource_group_name       = var.resource_group_name
  dns_prefix                = var.dns_prefix
  kubernetes_version        = var.kubernetes_version
  private_cluster_enabled   = var.private_cluster_enabled
  automatic_upgrade_channel = var.automatic_upgrade_channel
  sku_tier                  = var.sku_tier
  tags                      = var.tags
  default_node_pool {
    name                 = "system"
    vm_size              = var.node_vm_size
    node_count           = var.node_count
    min_count            = var.min_count
    max_count            = var.max_count
    auto_scaling_enabled = true
    vnet_subnet_id       = var.subnet_id
  }
  identity {
    type = "SystemAssigned"
  }
  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
  }

}
