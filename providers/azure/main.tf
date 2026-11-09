locals {
  azure_common_tags = merge(var.common_tags, { Environment = var.environment })

  azure_web_app_definitions = concat(
    [
      for app in var.azure_web_apps : {
        key                           = app.key
        name                          = app.name
        resource_group_name           = app.resource_group_name
        location                      = app.location
        service_plan_id               = app.service_plan_id != null ? app.service_plan_id : try(module.azure_app_service[app.service_plan_key].id, null)
        public_network_access_enabled = app.public_network_access_enabled
        integration_subnet_id         = app.integration_subnet_id
        identity_ids                  = concat(app.identity_ids, [for identity_key in app.user_assigned_identity_keys : module.azure_managed_identity[identity_key].id])
        app_settings                  = app.app_settings
        tags                          = merge(local.azure_common_tags, app.tags)
        runtime                       = app.runtime
        prevent_destroy               = app.prevent_destroy
      }
    ],
    [
      for app_name in var.azure_web_app_names : {
        key                           = app_name
        name                          = app_name
        resource_group_name           = var.azure_web_app_defaults.resource_group_name
        location                      = var.azure_web_app_defaults.location
        service_plan_id               = coalesce(try(var.azure_web_app_defaults.service_plan_id, null), try(module.azure_app_service[var.azure_web_app_defaults.service_plan_key].id, null))
        public_network_access_enabled = var.azure_web_app_defaults.public_network_access_enabled
        integration_subnet_id         = var.azure_web_app_defaults.integration_subnet_id
        identity_ids                  = concat(var.azure_web_app_defaults.identity_ids, [for identity_key in var.azure_web_app_defaults.user_assigned_identity_keys : module.azure_managed_identity[identity_key].id])
        app_settings                  = var.azure_web_app_defaults.app_settings
        tags                          = merge(local.azure_common_tags, var.azure_web_app_defaults.tags)
        runtime                       = var.azure_web_app_defaults.runtime
        prevent_destroy               = var.azure_web_app_defaults.prevent_destroy
      }
    ]
  )

  azure_sql_database_definitions = concat(
    var.azure_sql_database,
    [
      for database_name in var.azure_sql_database_names : {
        key                   = database_name
        name                  = database_name
        server_id             = var.azure_sql_database_defaults.server_id
        server_key            = var.azure_sql_database_defaults.server_key
        sku_name              = var.azure_sql_database_defaults.sku_name
        zone_redundant        = var.azure_sql_database_defaults.zone_redundant
        storage_account_type  = var.azure_sql_database_defaults.storage_account_type
        min_capacity          = var.azure_sql_database_defaults.min_capacity
        backup_retention_days = var.azure_sql_database_defaults.backup_retention_days
        tags                  = var.azure_sql_database_defaults.tags
        prevent_destroy       = var.azure_sql_database_defaults.prevent_destroy
      }
    ]
  )
}

module "azure_acr" {
  source   = "./module/acr"
  for_each = { for item in var.azure_acr : item.key => item }
  name = try(each.value.name, null)
  resource_group_name = try(each.value.resource_group_name, null)
  location = try(each.value.location, null)
  sku = try(each.value.sku, null)
  public_network_access_enabled = try(each.value.public_network_access_enabled, null)
  tags = merge(local.azure_common_tags, try(each.value.tags, {}))
}

module "azure_aks" {
  source   = "./module/aks"
  for_each = { for item in var.azure_aks : item.key => item }
  name = try(each.value.name, null)
  resource_group_name = try(each.value.resource_group_name, null)
  location = try(each.value.location, null)
  tags = merge(local.azure_common_tags, try(each.value.tags, {}))
  dns_prefix = try(each.value.dns_prefix, null)
  kubernetes_version = try(each.value.kubernetes_version, null)
  private_cluster_enabled = try(each.value.private_cluster_enabled, null)
  automatic_upgrade_channel = try(each.value.automatic_upgrade_channel, null)
  sku_tier = try(each.value.sku_tier, null)
  node_vm_size = try(each.value.node_vm_size, null)
  node_count = try(each.value.node_count, null)
  min_count = try(each.value.min_count, null)
  max_count = try(each.value.max_count, null)
  subnet_id = coalesce(try(each.value.subnet_id, null), try(module.azure_subnet[each.value.subnet_key].id, null))
}

module "azure_app_configuration" {
  source   = "./module/app_configuration"
  for_each = { for item in var.azure_app_configuration : item.key => item }
  name = try(each.value.name, null)
  resource_group_name = try(each.value.resource_group_name, null)
  location = try(each.value.location, null)
  tags = merge(local.azure_common_tags, try(each.value.tags, {}))
  sku = try(each.value.sku, null)
  public_network_access = try(each.value.public_network_access, null)
  configuration = try(each.value.configuration, null)
  label = try(each.value.label, null)
}

module "azure_app_service" {
  source   = "./module/app_service"
  for_each = { for item in var.azure_app_service : item.key => item }
  name = try(each.value.name, null)
  resource_group_name = try(each.value.resource_group_name, null)
  location = try(each.value.location, null)
  tags = merge(local.azure_common_tags, try(each.value.tags, {}))
  os_type = try(each.value.os_type, null)
  sku_name = try(each.value.sku_name, null)
}

module "azure_event_grid" {
  source   = "./module/event_grid"
  for_each = { for item in var.azure_event_grid : item.key => item }
  name = try(each.value.name, null)
  resource_group_name = try(each.value.resource_group_name, null)
  location = try(each.value.location, null)
  public_network_access_enabled = try(each.value.public_network_access_enabled, null)
  tags = merge(local.azure_common_tags, try(each.value.tags, {}))
  publisher_principal_ids = try(each.value.publisher_principal_ids, null)
}

module "azure_function_app" {
  source   = "./module/function_app"
  for_each = { for item in var.azure_function_app : item.key => item }
  name = try(each.value.name, null)
  resource_group_name = try(each.value.resource_group_name, null)
  location = try(each.value.location, null)
  tags = merge(local.azure_common_tags, try(each.value.tags, {}))
  service_plan_id = coalesce(try(each.value.service_plan_id, null), try(module.azure_app_service[each.value.service_plan_key].id, null))
  storage_account_name = coalesce(try(each.value.storage_account_name, null), try(module.azure_storage_account[each.value.storage_account_key].name, null))
  python_version = try(each.value.python_version, null)
  integration_subnet_id = try(each.value.integration_subnet_id, null)
  public_network_access_enabled = try(each.value.public_network_access_enabled, null)
}

module "azure_key_vault" {
  source   = "./module/key_vault"
  for_each = { for item in var.azure_key_vault : item.key => item }
  name = try(each.value.name, null)
  resource_group_name = try(each.value.resource_group_name, null)
  location = try(each.value.location, null)
  tenant_id = try(each.value.tenant_id, var.tenant_id)
  sku_name = try(each.value.sku_name, null)
  rbac_authorization_enabled = try(each.value.rbac_authorization_enabled, true)
  public_network_access_enabled = try(each.value.public_network_access_enabled, false)
  soft_delete_retention_days = try(each.value.soft_delete_retention_days, 90)
  access_policies = try(each.value.access_policies, {})
  tags = merge(local.azure_common_tags, try(each.value.tags, {}))
  role_assignments = merge(
    try(each.value.role_assignments, {}),
    {
      for app in var.azure_web_apps : "${app.name}-system-secrets-user" => {
        principal_id         = module.azure_web_apps.identity_principal_ids[app.key]
        role_definition_name = try(app.key_vault_role, "Key Vault Secrets User")
      }
      if contains(try(app.key_vaults, []), each.key)
    },
    {
      for identity in var.azure_managed_identity : "${identity.key}-secrets-user" => {
        principal_id         = module.azure_managed_identity[identity.key].principal_id
        role_definition_name = try(identity.key_vault_role, "Key Vault Secrets User")
      }
      if contains(try(identity.key_vaults, []), each.key)
    }
  )
}

module "azure_logic_app" {
  source   = "./module/logic_app"
  for_each = { for item in var.azure_logic_app : item.key => item }
  name = try(each.value.name, null)
  resource_group_name = try(each.value.resource_group_name, null)
  location = try(each.value.location, null)
  tags = merge(local.azure_common_tags, try(each.value.tags, {}))
  workflow_schema = try(each.value.workflow_schema, null)
  workflow_version = try(each.value.workflow_version, null)
}

module "azure_monitoring" {
  source   = "./module/monitoring"
  for_each = { for item in var.azure_monitoring : item.key => item }
  name = try(each.value.name, null)
  resource_group_name = try(each.value.resource_group_name, null)
  location = try(each.value.location, null)
  aks_cluster_id = coalesce(try(each.value.aks_cluster_id, null), try(module.azure_aks[each.value.aks_key].id, null))
  tags = merge(local.azure_common_tags, try(each.value.tags, {}))
}

module "azure_resource_group" {
  source   = "./module/resource_group"
  for_each = { for item in var.azure_resource_group : item.key => item }
  name = try(each.value.name, null)
  location = try(each.value.location, null)
  tags = merge(local.azure_common_tags, try(each.value.tags, {}))
}

module "azure_sql_database" {
  source   = "./module/sql_database"
  for_each = { for item in local.azure_sql_database_definitions : item.key => item }
  name = try(each.value.name, null)
  server_id = each.value.server_id != null ? each.value.server_id : module.azure_sql_server[each.value.server_key].id
  sku_name = try(each.value.sku_name, null)
  zone_redundant = try(each.value.zone_redundant, null)
  storage_account_type = try(each.value.storage_account_type, null)
  min_capacity = try(each.value.min_capacity, null)
  backup_retention_days = try(each.value.backup_retention_days, null)
  prevent_destroy = try(each.value.prevent_destroy, true)
  tags = merge(local.azure_common_tags, try(each.value.tags, {}))
}

module "azure_sql_server" {
  source   = "./module/sql_server"
  for_each = { for item in var.azure_sql_server : item.key => item }
  name = try(each.value.name, null)
  resource_group_name = try(each.value.resource_group_name, null)
  location = try(each.value.location, null)
  tags = merge(local.azure_common_tags, try(each.value.tags, {}))
  sql_server_version = try(each.value.sql_server_version, null)
  administrator_login = try(var.azure_sql_server_credentials[each.key].administrator_login, null)
  administrator_login_password = try(var.azure_sql_server_credentials[each.key].administrator_login_password, null)
  azuread_admin_login = try(each.value.azuread_admin_login, null)
  azuread_admin_object_id = try(each.value.azuread_admin_object_id, null)
  tenant_id = try(each.value.tenant_id, var.tenant_id)
  public_network_access_enabled = try(each.value.public_network_access_enabled, null)
  prevent_destroy = try(each.value.prevent_destroy, true)
}

module "azure_storage_account" {
  source   = "./module/storage_account"
  for_each = { for item in var.azure_storage_account : item.key => item }
  name = try(each.value.name, null)
  resource_group_name = try(each.value.resource_group_name, null)
  location = try(each.value.location, null)
  tags = merge(local.azure_common_tags, try(each.value.tags, {}))
  account_tier = try(each.value.account_tier, null)
  replication_type = try(each.value.replication_type, null)
  public_network_access_enabled = try(each.value.public_network_access_enabled, null)
  containers = try(each.value.containers, null)
  blobs = try(each.value.blobs, null)
}

module "azure_subnet" {
  source   = "./module/subnet"
  for_each = { for item in var.azure_subnet : item.key => item }
  name = try(each.value.name, null)
  resource_group_name = try(each.value.resource_group_name, null)
  virtual_network_name = coalesce(try(each.value.virtual_network_name, null), try(module.azure_vnet[each.value.vnet_key].name, null))
  address_prefixes = try(each.value.address_prefixes, null)
  service_endpoints = try(each.value.service_endpoints, null)
}

module "azure_vnet" {
  source   = "./module/vnet"
  for_each = { for item in var.azure_vnet : item.key => item }
  name = try(each.value.name, null)
  resource_group_name = try(each.value.resource_group_name, null)
  location = try(each.value.location, null)
  tags = merge(local.azure_common_tags, try(each.value.tags, {}))
  address_space = try(each.value.address_space, null)
}

module "azure_managed_identity" {
  source   = "./module/managed_identity"
  for_each = { for item in var.azure_managed_identity : item.key => item }
  name                = try(each.value.name, null)
  resource_group_name = try(each.value.resource_group_name, null)
  location            = try(each.value.location, null)
  tags                = merge(local.azure_common_tags, try(each.value.tags, {}))
}

module "azure_private_endpoint" {
  source   = "./module/private_endpoint"
  for_each = { for item in var.azure_private_endpoint : item.key => item }
  name                           = try(each.value.name, null)
  resource_group_name            = try(each.value.resource_group_name, null)
  location                       = try(each.value.location, null)
  subnet_id                      = try(each.value.subnet_id, null)
  private_connection_resource_id = try(each.value.private_connection_resource_id, null)
  subresource_names              = try(each.value.subresource_names, null)
  is_manual_connection           = try(each.value.is_manual_connection, false)
  request_message                = try(each.value.request_message, null)
  private_dns_zone_ids           = try(each.value.private_dns_zone_ids, [])
  tags                           = merge(local.azure_common_tags, try(each.value.tags, {}))
}

module "azure_web_apps" {
  source = "./module/web_app"
  apps   = local.azure_web_app_definitions
}

module "azure_service_bus" {
  source = "./module/service_bus"
  namespaces = {
    for item in var.azure_service_bus_namespaces : item.key => {
      name                          = item.name
      resource_group_name           = item.resource_group_name
      location                      = item.location
      sku                           = try(item.sku, "Premium")
      capacity                      = try(item.capacity, 1)
      public_network_access_enabled = try(item.public_network_access_enabled, false)
      tags                          = merge(local.azure_common_tags, try(item.tags, {}))
      queues                        = try(item.queues, {})
      topics                        = try(item.topics, {})
    }
  }
}

output "azure_acr_outputs" {
  description = "Outputs from every acr module instance."
  sensitive   = true
  value = module.azure_acr
}

output "azure_aks_outputs" {
  description = "Outputs from every aks module instance."
  sensitive   = true
  value = module.azure_aks
}

output "azure_app_configuration_outputs" {
  description = "Outputs from every app_configuration module instance."
  sensitive   = true
  value = module.azure_app_configuration
}

output "azure_app_service_outputs" {
  description = "Outputs from every app_service module instance."
  sensitive   = true
  value = module.azure_app_service
}

output "azure_event_grid_outputs" {
  description = "Outputs from every event_grid module instance."
  sensitive   = true
  value = module.azure_event_grid
}

output "azure_function_app_outputs" {
  description = "Outputs from every function_app module instance."
  sensitive   = true
  value = module.azure_function_app
}

output "azure_key_vault_outputs" {
  description = "Outputs from every key_vault module instance."
  sensitive   = true
  value = module.azure_key_vault
}

output "azure_logic_app_outputs" {
  description = "Outputs from every logic_app module instance."
  sensitive   = true
  value = module.azure_logic_app
}

output "azure_monitoring_outputs" {
  description = "Outputs from every monitoring module instance."
  sensitive   = true
  value = module.azure_monitoring
}

output "azure_resource_group_outputs" {
  description = "Outputs from every resource_group module instance."
  sensitive   = true
  value = module.azure_resource_group
}

output "azure_service_bus_outputs" {
  description = "Outputs from every service_bus module instance."
  sensitive   = true
  value = module.azure_service_bus
}

output "azure_sql_database_outputs" {
  description = "Outputs from every sql_database module instance."
  sensitive   = true
  value = module.azure_sql_database
}

output "azure_sql_server_outputs" {
  description = "Outputs from every sql_server module instance."
  sensitive   = true
  value = module.azure_sql_server
}

output "azure_storage_account_outputs" {
  description = "Outputs from every storage_account module instance."
  sensitive   = true
  value = module.azure_storage_account
}

output "azure_subnet_outputs" {
  description = "Outputs from every subnet module instance."
  sensitive   = true
  value = module.azure_subnet
}

output "azure_vnet_outputs" {
  description = "Outputs from every vnet module instance."
  sensitive   = true
  value = module.azure_vnet
}

output "azure_web_apps_outputs" {
  description = "Outputs from every web_app module instance."
  sensitive   = true
  value = module.azure_web_apps
}

output "azure_managed_identity_outputs" {
  description = "Outputs from all user-assigned managed identity instances."
  sensitive   = true
  value       = module.azure_managed_identity
}

output "azure_private_endpoint_outputs" {
  description = "Outputs from all private endpoint instances."
  sensitive   = true
  value       = module.azure_private_endpoint
}
