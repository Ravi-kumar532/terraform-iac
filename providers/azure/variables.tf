variable "environment" {
  description = "Deployment environment; each environment uses a distinct remote state key and approval boundary."
  type        = string
  validation {
    condition     = contains(["dev", "qa", "staging", "prod"], var.environment)
    error_message = "environment must be dev, qa, staging, or prod."
  }
}
variable "tenant_id" {
  type = string
  description = "Microsoft Entra tenant ID."
}
variable "subscription_id" {
  type = string
  description = "Azure subscription ID."
}
variable "client_id" {
  type = string
  description = "OIDC federated deployment application/client ID."
}
variable "common_tags" {
  type = map(string)
  default = {}
  description = "Common resource tags merged with per-resource tags."
}
variable "azure_sql_server_credentials" {
  description = "SQL administrator credentials injected by the secret manager at deployment time; never commit values."
  type = map(object({ administrator_login = string, administrator_login_password = string }))
  sensitive = true
  default = {}
}

variable "azure_acr" {
  description = "Typed list of ACR resources with stable Terraform keys."
  type = list(object({
    key                           = string
    name                          = string
    resource_group_name           = string
    location                      = string
    sku                           = optional(string, "Premium")
    public_network_access_enabled = optional(bool, false)
    tags                          = optional(map(string), {})
  }))
  default = []
  validation {
    condition = alltrue([for item in var.azure_acr : length(trimspace(item.key)) > 0]) && length(distinct([for item in var.azure_acr : item.key])) == length(var.azure_acr)
    error_message = "Each ACR item must have a unique non-empty key."
  }
}

variable "azure_aks" {
  description = "Typed list of aks resources. Each object has a stable key for Terraform state identity."
  type = list(object({
    key = string
    name = string
    resource_group_name = string
    location = string
    tags = optional(map(string), {

  })
    dns_prefix = string
    kubernetes_version = optional(string, null)
    private_cluster_enabled = optional(bool, true)
    automatic_upgrade_channel = optional(string, "patch")
    sku_tier = optional(string, "Standard")
    node_vm_size = optional(string, "Standard_D4s_v5")
    node_count = optional(number, 3)
    min_count = optional(number, 3)
    max_count = optional(number, 10)
    subnet_id = optional(string)
    subnet_key = optional(string)
  }))
  default = []
  validation {
    condition = alltrue([for item in var.azure_aks : length(trimspace(item.key)) > 0]) && length(distinct([for item in var.azure_aks : item.key])) == length(var.azure_aks)
    error_message = "Each azure_aks item must have a unique non-empty key."
  }
}

variable "azure_app_configuration" {
  description = "Typed list of app_configuration resources. Each object has a stable key for Terraform state identity."
  type = list(object({
    key = string
    name = string
    resource_group_name = string
    location = string
    tags = optional(map(string), {

  })
    sku = optional(string, "standard")
    public_network_access = optional(string, "Disabled")
    configuration = optional(map(string), {})
    label = optional(string, null)
  }))
  default = []
  validation {
    condition = alltrue([for item in var.azure_app_configuration : length(trimspace(item.key)) > 0]) && length(distinct([for item in var.azure_app_configuration : item.key])) == length(var.azure_app_configuration)
    error_message = "Each azure_app_configuration item must have a unique non-empty key."
  }
}

variable "azure_app_service" {
  description = "Typed list of app_service resources. Each object has a stable key for Terraform state identity."
  type = list(object({
    key = string
    name = string
    resource_group_name = string
    location = string
    tags = optional(map(string), {

  })
    os_type = optional(string, "Linux")
    sku_name = optional(string, "P1v3")
  }))
  default = []
  validation {
    condition = alltrue([for item in var.azure_app_service : length(trimspace(item.key)) > 0]) && length(distinct([for item in var.azure_app_service : item.key])) == length(var.azure_app_service)
    error_message = "Each azure_app_service item must have a unique non-empty key."
  }
}

variable "azure_event_grid" {
  description = "Typed list of event_grid resources. Each object has a stable key for Terraform state identity."
  type = list(object({
    key = string
    name = string
    resource_group_name = string
    location = string
    public_network_access_enabled = optional(bool, false)
    tags = optional(map(string), {})
    publisher_principal_ids = optional(set(string), [])
  }))
  default = []
  validation {
    condition = alltrue([for item in var.azure_event_grid : length(trimspace(item.key)) > 0]) && length(distinct([for item in var.azure_event_grid : item.key])) == length(var.azure_event_grid)
    error_message = "Each azure_event_grid item must have a unique non-empty key."
  }
}

variable "azure_function_app" {
  description = "Typed list of function_app resources. Each object has a stable key for Terraform state identity."
  type = list(object({
    key = string
    name = string
    resource_group_name = string
    location = string
    tags = optional(map(string), {

  })
    service_plan_id = optional(string)
    storage_account_name = optional(string)
    python_version = optional(string, "3.11")
    integration_subnet_id = optional(string, null)
    public_network_access_enabled = optional(bool, false)
    service_plan_key = optional(string)
    storage_account_key = optional(string)
  }))
  default = []
  validation {
    condition = alltrue([for item in var.azure_function_app : length(trimspace(item.key)) > 0]) && length(distinct([for item in var.azure_function_app : item.key])) == length(var.azure_function_app)
    error_message = "Each azure_function_app item must have a unique non-empty key."
  }
}

variable "azure_key_vault" {
  description = "Typed list of key_vault resources. Each object has a stable key for Terraform state identity."
  type = list(object({
    key = string
    name = string
    resource_group_name = string
    location = string
    tenant_id = string
    sku_name = optional(string, "standard")
    rbac_authorization_enabled = optional(bool, true)
    public_network_access_enabled = optional(bool, false)
    soft_delete_retention_days = optional(number, 90)
    access_policies = optional(map(object({
    tenant_id               = string
    object_id               = string
    secret_permissions      = optional(list(string), ["Get", "List"])
    key_permissions         = optional(list(string), [])
    certificate_permissions = optional(list(string), [])
    storage_permissions     = optional(list(string), [])
  })), {})
    role_assignments = optional(map(object({
    principal_id         = string
    role_definition_name = string
    description          = optional(string)
    principal_type       = optional(string)
    skip_service_principal_aad_check = optional(bool, false)
  })), {})
    tags = optional(map(string), {})
  }))
  default = []
  validation {
    condition = alltrue([for item in var.azure_key_vault : length(trimspace(item.key)) > 0]) && length(distinct([for item in var.azure_key_vault : item.key])) == length(var.azure_key_vault)
    error_message = "Each azure_key_vault item must have a unique non-empty key."
  }
}

variable "azure_logic_app" {
  description = "Typed list of logic_app resources. Each object has a stable key for Terraform state identity."
  type = list(object({
    key = string
    name = string
    resource_group_name = string
    location = string
    tags = optional(map(string), {

  })
    workflow_schema = string
    workflow_version = optional(string, "1.0.0.0")
  }))
  default = []
  validation {
    condition = alltrue([for item in var.azure_logic_app : length(trimspace(item.key)) > 0]) && length(distinct([for item in var.azure_logic_app : item.key])) == length(var.azure_logic_app)
    error_message = "Each azure_logic_app item must have a unique non-empty key."
  }
}

variable "azure_monitoring" {
  description = "Typed list of monitoring resources. Each object has a stable key for Terraform state identity."
  type = list(object({
    key = string
    name = string
    resource_group_name = string
    location = string
    aks_cluster_id = optional(string)
    tags = optional(map(string), {})
    aks_key = optional(string)
  }))
  default = []
  validation {
    condition = alltrue([for item in var.azure_monitoring : length(trimspace(item.key)) > 0]) && length(distinct([for item in var.azure_monitoring : item.key])) == length(var.azure_monitoring)
    error_message = "Each azure_monitoring item must have a unique non-empty key."
  }
}

variable "azure_resource_group" {
  description = "Typed list of resource_group resources. Each object has a stable key for Terraform state identity."
  type = list(object({
    key = string
    name = string
    location = string
    tags = optional(map(string), {

  })
  }))
  default = []
  validation {
    condition = alltrue([for item in var.azure_resource_group : length(trimspace(item.key)) > 0]) && length(distinct([for item in var.azure_resource_group : item.key])) == length(var.azure_resource_group)
    error_message = "Each azure_resource_group item must have a unique non-empty key."
  }
}





variable "azure_sql_database" {
  description = "Repeatable SQL databases. Stable keys are Terraform state identities; server_key links a database to a server in this root."
  type = list(object({
    key                   = string
    name                  = string
    server_id             = optional(string)
    server_key            = optional(string)
    sku_name              = optional(string, "GP_S_Gen5_2")
    zone_redundant         = optional(bool, true)
    storage_account_type  = optional(string, "Geo")
    min_capacity          = optional(number, 0.5)
    backup_retention_days = optional(number, 35)
    tags                  = optional(map(string), {})
    prevent_destroy       = optional(bool, true)
  }))
  default = []
  validation {
    condition = alltrue([
      for database in var.azure_sql_database :
      length(trimspace(database.key)) > 0 &&
      length(trimspace(database.name)) > 0 &&
      (database.server_id != null || database.server_key != null)
    ]) && length(distinct([for database in var.azure_sql_database : database.key])) == length(var.azure_sql_database)
      && length(distinct([for database in var.azure_sql_database : lower("${coalesce(database.server_key, database.server_id, "missing")}:${database.name}")])) == length(var.azure_sql_database)
    error_message = "Each SQL database requires a unique key, unique name per server, and either server_id or server_key."
  }
}

variable "azure_sql_database_names" {
  description = "Convenience array of SQL database names sharing the defaults below. Use azure_sql_database objects for per-database overrides or stable keys independent of database names."
  type        = list(string)
  default     = []
  validation {
    condition = length(distinct([for name in var.azure_sql_database_names : lower(trimspace(name))])) == length(var.azure_sql_database_names)
      && length(setintersection(toset([for name in var.azure_sql_database_names : lower(trimspace(name))]), toset(concat([for database in var.azure_sql_database : lower(database.name)], [for database in var.azure_sql_database : lower(database.key)])))) == 0
    error_message = "azure_sql_database_names must be unique and must not duplicate names in azure_sql_database."
  }
}

variable "azure_sql_database_defaults" {
  description = "Shared SQL Server association and database settings applied to every name in azure_sql_database_names."
  type = object({
    server_id             = optional(string)
    server_key            = optional(string)
    sku_name              = optional(string, "GP_S_Gen5_2")
    zone_redundant         = optional(bool, true)
    storage_account_type  = optional(string, "Geo")
    min_capacity          = optional(number, 0.5)
    backup_retention_days = optional(number, 35)
    tags                  = optional(map(string), {})
    prevent_destroy       = optional(bool, true)
  })
  default = {}
  validation {
    condition = length(var.azure_sql_database_names) == 0 || (
      try(length(trimspace(var.azure_sql_database_defaults.server_id)) > 0, false) ||
      try(length(trimspace(var.azure_sql_database_defaults.server_key)) > 0, false)
    )
    error_message = "When azure_sql_database_names is non-empty, defaults must include server_id or server_key."
  }
}

variable "azure_sql_server" {
  description = "Azure SQL servers. Credentials are injected separately from Key Vault and keyed by this stable Terraform key."
  type = list(object({
    key                           = string
    name                          = string
    resource_group_name           = string
    location                      = string
    tags                          = optional(map(string), {})
    sql_server_version            = optional(string, "12.0")
    administrator_login           = optional(string)
    administrator_login_password  = optional(string)
    azuread_admin_login           = string
    azuread_admin_object_id       = string
    tenant_id                     = optional(string)
    public_network_access_enabled = optional(bool, false)
    prevent_destroy               = optional(bool, true)
  }))
  default = []
  validation {
    condition = alltrue([for item in var.azure_sql_server : length(trimspace(item.key)) > 0 && length(trimspace(item.name)) > 0]) && length(distinct([for item in var.azure_sql_server : item.key])) == length(var.azure_sql_server)
    error_message = "Each SQL server must have a unique non-empty key and name."
  }
}

variable "azure_storage_account" {
  description = "Typed list of storage_account resources. Each object has a stable key for Terraform state identity."
  type = list(object({
    key = string
    name = string
    resource_group_name = string
    location = string
    tags = optional(map(string), {

  })
    account_tier = optional(string, "Standard")
    replication_type = optional(string, "ZRS")
    public_network_access_enabled = optional(bool, false)
    containers = optional(map(string), {})
    blobs = optional(map(object({
    name         = string
    container    = string
    source       = string
    content_type = optional(string)
    type         = optional(string, "Block")
  })), {})
  }))
  default = []
  validation {
    condition = alltrue([for item in var.azure_storage_account : length(trimspace(item.key)) > 0]) && length(distinct([for item in var.azure_storage_account : item.key])) == length(var.azure_storage_account)
    error_message = "Each azure_storage_account item must have a unique non-empty key."
  }
}

variable "azure_subnet" {
  description = "Typed list of subnet resources. Each object has a stable key for Terraform state identity."
  type = list(object({
    key = string
    name = string
    resource_group_name = string
    virtual_network_name = optional(string)
    address_prefixes = list(string)
    service_endpoints = optional(list(string), [])
    vnet_key = optional(string)
  }))
  default = []
  validation {
    condition = alltrue([for item in var.azure_subnet : length(trimspace(item.key)) > 0]) && length(distinct([for item in var.azure_subnet : item.key])) == length(var.azure_subnet)
    error_message = "Each azure_subnet item must have a unique non-empty key."
  }
}

variable "azure_vnet" {
  description = "Typed list of vnet resources. Each object has a stable key for Terraform state identity."
  type = list(object({
    key = string
    name = string
    resource_group_name = string
    location = string
    tags = optional(map(string), {

  })
    address_space = list(string)
  }))
  default = []
  validation {
    condition = alltrue([for item in var.azure_vnet : length(trimspace(item.key)) > 0]) && length(distinct([for item in var.azure_vnet : item.key])) == length(var.azure_vnet)
    error_message = "Each azure_vnet item must have a unique non-empty key."
  }
}

variable "azure_web_apps" {
  description = "Repeatable Web App definitions. One object per app; stable key is the Terraform identity, name is the Azure resource name."
  type = list(object({
    key                           = string
    name                          = string
    resource_group_name           = string
    location                      = string
    service_plan_id               = optional(string)
    service_plan_key              = optional(string)
    public_network_access_enabled = optional(bool, false)
    integration_subnet_id         = optional(string)
    identity_ids                  = optional(list(string), [])
    user_assigned_identity_keys   = optional(list(string), [])
    key_vaults                    = optional(list(string), [])
    key_vault_role                = optional(string, "Key Vault Secrets User")
    prevent_destroy               = optional(bool, true)
    app_settings                  = optional(map(string), {})
    tags                          = optional(map(string), {})
    runtime = optional(object({
      python_version      = optional(string)
      node_version        = optional(string)
      php_version         = optional(string)
      dotnet_version      = optional(string)
      ruby_version        = optional(string)
      java_version        = optional(string)
      java_server         = optional(string)
      java_server_version = optional(string)
    }), {})
  }))
  default = []
  validation {
    condition = alltrue([
      for app in var.azure_web_apps :
      length(trimspace(app.key)) > 0 &&
      length(trimspace(app.name)) > 0 &&
      length(trimspace(app.resource_group_name)) > 0 &&
      length(trimspace(app.location)) > 0 &&
      (app.service_plan_id != null || app.service_plan_key != null)
    ]) && length(distinct([for app in var.azure_web_apps : app.key])) == length(var.azure_web_apps)
      && length(distinct([for app in var.azure_web_apps : lower(app.name)])) == length(var.azure_web_apps)
    error_message = "Each Web App requires a unique key/name, resource group, location, and either service_plan_id or service_plan_key."
  }
}
variable "azure_web_app_names" {
  description = "Convenience array of Web App names for apps sharing the common defaults below. Use azure_web_apps objects when apps need per-app overrides or stable keys independent of Azure names."
  type        = list(string)
  default     = []
  validation {
    condition = length(distinct([for name in var.azure_web_app_names : lower(trimspace(name))])) == length(var.azure_web_app_names)
      && length(setintersection(toset([for name in var.azure_web_app_names : lower(trimspace(name))]), toset(concat([for app in var.azure_web_apps : lower(app.name)], [for app in var.azure_web_apps : lower(app.key)])))) == 0
    error_message = "azure_web_app_names must be unique and must not duplicate names in azure_web_apps."
  }
}

variable "azure_web_app_defaults" {
  description = "Shared configuration applied to each name in azure_web_app_names. Resource group, location, and a service plan ID or key are required when the names array is non-empty."
  type = object({
    resource_group_name           = optional(string)
    location                      = optional(string)
    service_plan_id               = optional(string)
    service_plan_key              = optional(string)
    public_network_access_enabled = optional(bool, false)
    integration_subnet_id         = optional(string)
    identity_ids                  = optional(list(string), [])
    user_assigned_identity_keys   = optional(list(string), [])
    key_vaults                    = optional(list(string), [])
    key_vault_role                = optional(string, "Key Vault Secrets User")
    prevent_destroy               = optional(bool, true)
    app_settings                  = optional(map(string), {})
    tags                          = optional(map(string), {})
    runtime = optional(object({
      python_version      = optional(string)
      node_version        = optional(string)
      php_version         = optional(string)
      dotnet_version      = optional(string)
      ruby_version        = optional(string)
      java_version        = optional(string)
      java_server         = optional(string)
      java_server_version = optional(string)
    }), {})
  })
  default = {}
  validation {
    condition = length(var.azure_web_app_names) == 0 || (
      try(length(trimspace(var.azure_web_app_defaults.resource_group_name)) > 0, false) &&
      try(length(trimspace(var.azure_web_app_defaults.location)) > 0, false) &&
      (try(length(trimspace(var.azure_web_app_defaults.service_plan_id)) > 0, false) || try(length(trimspace(var.azure_web_app_defaults.service_plan_key)) > 0, false))
    )
    error_message = "When azure_web_app_names is non-empty, defaults must include resource_group_name, location, and service_plan_id or service_plan_key."
  }
}

variable "azure_service_bus_namespaces" {
  description = "Repeatable Service Bus namespaces with keyed queues and topics."
  type = list(object({
    key                           = string
    name                          = string
    resource_group_name           = string
    location                      = string
    sku                           = optional(string, "Premium")
    capacity                      = optional(number, 1)
    public_network_access_enabled = optional(bool, false)
    tags                          = optional(map(string), {})
    queues = optional(map(object({
      name                                    = string
      lock_duration                           = optional(string, "PT1M")
      max_delivery_count                      = optional(number, 10)
      dead_lettering_on_message_expiration    = optional(bool, true)
      requires_duplicate_detection            = optional(bool, true)
      duplicate_detection_history_time_window = optional(string, "PT10M")
    })), {})
    topics = optional(map(object({
      name                                    = string
      requires_duplicate_detection            = optional(bool, true)
      duplicate_detection_history_time_window = optional(string, "PT10M")
    })), {})
  }))
  default = []
  validation {
    condition = alltrue([for item in var.azure_service_bus_namespaces : length(trimspace(item.key)) > 0]) && length(distinct([for item in var.azure_service_bus_namespaces : item.key])) == length(var.azure_service_bus_namespaces)
    error_message = "Each Service Bus namespace must have a unique non-empty key."
  }
}

variable "azure_managed_identity" {
  description = "Typed list of managed_identity resources. Each object has a stable key for Terraform state identity."
  type = list(object({
    key = string
    name = string
    resource_group_name = string
    location = string
    tags = optional(map(string), {})
  }))
  default = []
  validation {
    condition = alltrue([for item in var.azure_managed_identity : length(trimspace(item.key)) > 0]) && length(distinct([for item in var.azure_managed_identity : item.key])) == length(var.azure_managed_identity)
    error_message = "Each azure_managed_identity item must have a unique non-empty key."
  }
}

variable "azure_private_endpoint" {
  description = "Typed list of private_endpoint resources. Each object has a stable key for Terraform state identity."
  type = list(object({
    key = string
    name = string
    resource_group_name = string
    location = string
    subnet_id = string
    private_connection_resource_id = string
    subresource_names = list(string)
    is_manual_connection = optional(bool, false)
    request_message = optional(string, null)
    private_dns_zone_ids = optional(list(string), [])
    tags = optional(map(string), {})
  }))
  default = []
  validation {
    condition = alltrue([for item in var.azure_private_endpoint : length(trimspace(item.key)) > 0]) && length(distinct([for item in var.azure_private_endpoint : item.key])) == length(var.azure_private_endpoint)
    error_message = "Each azure_private_endpoint item must have a unique non-empty key."
  }
}
