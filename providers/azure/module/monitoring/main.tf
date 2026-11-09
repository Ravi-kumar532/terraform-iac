resource "azurerm_monitor_workspace" "this" {
  name                = "${var.name}-prom"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

resource "azurerm_monitor_data_collection_endpoint" "prometheus" {
  name                          = "${var.name}-prom-dce"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  kind                          = "Linux"
  public_network_access_enabled = true
  tags                          = var.tags
}

resource "azurerm_monitor_data_collection_rule" "prometheus" {
  name                        = "${var.name}-prom-dcr"
  resource_group_name         = var.resource_group_name
  location                    = var.location
  data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.prometheus.id
  kind                        = "Linux"
  tags                        = var.tags

  destinations {
    monitor_account {
      name               = "azure-monitor-workspace"
      monitor_account_id = azurerm_monitor_workspace.this.id
    }
  }

  data_sources {
    prometheus_forwarder {
      name    = "prometheus-forwarder"
      streams = ["Microsoft-PrometheusMetrics"]
    }
  }

  data_flow {
    streams      = ["Microsoft-PrometheusMetrics"]
    destinations = ["azure-monitor-workspace"]
  }
}

resource "azurerm_monitor_data_collection_rule_association" "aks" {
  name                    = "${var.name}-prom-dcra"
  target_resource_id      = var.aks_cluster_id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.prometheus.id
  description             = "Collect managed Prometheus metrics from AKS."
}

resource "azurerm_dashboard_grafana" "this" {
  name                              = "${var.name}-grafana"
  resource_group_name               = var.resource_group_name
  location                          = var.location
  grafana_major_version             = "11"
  public_network_access_enabled     = true
  deterministic_outbound_ip_enabled = false
  api_key_enabled                   = false
  zone_redundancy_enabled           = true
  tags                              = var.tags

  azure_monitor_workspace_integrations {
    resource_id = azurerm_monitor_workspace.this.id
  }

  depends_on = [azurerm_monitor_data_collection_rule_association.aks]
}
