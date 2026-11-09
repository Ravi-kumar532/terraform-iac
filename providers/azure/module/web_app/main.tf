locals {
  apps = {
    for app in var.apps : app.name => app
  }
}

resource "azurerm_linux_web_app" "this" {
  for_each = local.apps

  name                          = each.value.name
  resource_group_name           = each.value.resource_group_name
  location                      = each.value.location
  service_plan_id               = each.value.service_plan_id
  https_only                    = true
  public_network_access_enabled = each.value.public_network_access_enabled
  virtual_network_subnet_id     = each.value.integration_subnet_id
  app_settings                  = each.value.app_settings
  tags                          = each.value.tags

  identity {
    type         = length(each.value.identity_ids) > 0 ? "SystemAssigned, UserAssigned" : "SystemAssigned"
    identity_ids = each.value.identity_ids
  }

  site_config {
    minimum_tls_version = "1.2"
    ftps_state          = "Disabled"
    always_on           = true

    application_stack {
      python_version      = each.value.runtime.python_version
      node_version        = each.value.runtime.node_version
      php_version         = each.value.runtime.php_version
      dotnet_version      = each.value.runtime.dotnet_version
      ruby_version        = each.value.runtime.ruby_version
      java_version        = each.value.runtime.java_version
      java_server         = each.value.runtime.java_server
      java_server_version = each.value.runtime.java_server_version
    }
  }
}
