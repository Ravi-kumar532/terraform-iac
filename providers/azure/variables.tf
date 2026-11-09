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
  description = "Array of acr module instances. Each object requires a stable unique key plus the child module inputs."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.azure_acr : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.azure_acr : try(item.key, "")])) == length(var.azure_acr)
    error_message = "Each azure_acr item must have a unique non-empty key."
  }
}

variable "azure_aks" {
  description = "Array of aks module instances. Each object requires a stable unique key plus the child module inputs."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.azure_aks : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.azure_aks : try(item.key, "")])) == length(var.azure_aks)
    error_message = "Each azure_aks item must have a unique non-empty key."
  }
}

variable "azure_app_configuration" {
  description = "Array of app_configuration module instances. Each object requires a stable unique key plus the child module inputs."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.azure_app_configuration : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.azure_app_configuration : try(item.key, "")])) == length(var.azure_app_configuration)
    error_message = "Each azure_app_configuration item must have a unique non-empty key."
  }
}

variable "azure_app_service" {
  description = "Array of app_service module instances. Each object requires a stable unique key plus the child module inputs."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.azure_app_service : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.azure_app_service : try(item.key, "")])) == length(var.azure_app_service)
    error_message = "Each azure_app_service item must have a unique non-empty key."
  }
}

variable "azure_event_grid" {
  description = "Array of event_grid module instances. Each object requires a stable unique key plus the child module inputs."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.azure_event_grid : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.azure_event_grid : try(item.key, "")])) == length(var.azure_event_grid)
    error_message = "Each azure_event_grid item must have a unique non-empty key."
  }
}

variable "azure_function_app" {
  description = "Array of function_app module instances. Each object requires a stable unique key plus the child module inputs."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.azure_function_app : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.azure_function_app : try(item.key, "")])) == length(var.azure_function_app)
    error_message = "Each azure_function_app item must have a unique non-empty key."
  }
}

variable "azure_key_vault" {
  description = "Array of key_vault module instances. Each object requires a stable unique key plus the child module inputs."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.azure_key_vault : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.azure_key_vault : try(item.key, "")])) == length(var.azure_key_vault)
    error_message = "Each azure_key_vault item must have a unique non-empty key."
  }
}

variable "azure_logic_app" {
  description = "Array of logic_app module instances. Each object requires a stable unique key plus the child module inputs."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.azure_logic_app : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.azure_logic_app : try(item.key, "")])) == length(var.azure_logic_app)
    error_message = "Each azure_logic_app item must have a unique non-empty key."
  }
}

variable "azure_monitoring" {
  description = "Array of monitoring module instances. Each object requires a stable unique key plus the child module inputs."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.azure_monitoring : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.azure_monitoring : try(item.key, "")])) == length(var.azure_monitoring)
    error_message = "Each azure_monitoring item must have a unique non-empty key."
  }
}

variable "azure_resource_group" {
  description = "Array of resource_group module instances. Each object requires a stable unique key plus the child module inputs."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.azure_resource_group : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.azure_resource_group : try(item.key, "")])) == length(var.azure_resource_group)
    error_message = "Each azure_resource_group item must have a unique non-empty key."
  }
}

variable "azure_sql_database" {
  description = "Repeatable Azure SQL database definitions. Each database has a stable key and can reference a server by server_key."
  type = list(object({
    key                  = string
    name                 = string
    server_id            = optional(string)
    server_key           = optional(string)
    sku_name             = optional(string, "GP_S_Gen5_2")
    zone_redundant        = optional(bool, true)
    storage_account_type = optional(string, "Geo")
    min_capacity         = optional(number, 0.5)
    backup_retention_days = optional(number, 35)
    tags                 = optional(map(string), {})
  }))
  default = []
  validation {
    condition = alltrue([
      for database in var.azure_sql_database :
      length(trimspace(database.key)) > 0 &&
      length(trimspace(database.name)) > 0 &&
      (database.server_id != null || database.server_key != null)
    ]) && length(distinct([for database in var.azure_sql_database : database.key])) == length(var.azure_sql_database)
      && length(distinct([for database in var.azure_sql_database : lower(database.name)])) == length(var.azure_sql_database)
    error_message = "Each SQL database requires a unique key/name and either server_id or server_key."
  }
}

variable "azure_sql_server" {
  description = "Array of sql_server module instances. Each object requires a stable unique key plus the child module inputs."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.azure_sql_server : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.azure_sql_server : try(item.key, "")])) == length(var.azure_sql_server)
    error_message = "Each azure_sql_server item must have a unique non-empty key."
  }
}

variable "azure_storage_account" {
  description = "Array of storage_account module instances. Each object requires a stable unique key plus the child module inputs."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.azure_storage_account : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.azure_storage_account : try(item.key, "")])) == length(var.azure_storage_account)
    error_message = "Each azure_storage_account item must have a unique non-empty key."
  }
}

variable "azure_subnet" {
  description = "Array of subnet module instances. Each object requires a stable unique key plus the child module inputs."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.azure_subnet : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.azure_subnet : try(item.key, "")])) == length(var.azure_subnet)
    error_message = "Each azure_subnet item must have a unique non-empty key."
  }
}

variable "azure_vnet" {
  description = "Array of vnet module instances. Each object requires a stable unique key plus the child module inputs."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.azure_vnet : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.azure_vnet : try(item.key, "")])) == length(var.azure_vnet)
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
variable "azure_service_bus_namespaces" {
  description = "Array of Service Bus namespace definitions; each item requires a unique key."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.azure_service_bus_namespaces : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.azure_service_bus_namespaces : try(item.key, "")])) == length(var.azure_service_bus_namespaces)
    error_message = "Each Service Bus namespace item must have a unique non-empty key."
  }
}

variable "azure_managed_identity" {
  description = "Array of user-assigned managed identities. key_vaults lists Azure Key Vault input keys that should grant this identity access."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.azure_managed_identity : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.azure_managed_identity : try(item.key, "")])) == length(var.azure_managed_identity)
    error_message = "Each managed identity item must have a unique non-empty key."
  }
}

variable "azure_private_endpoint" {
  description = "Array of private endpoints. Supply target resource IDs, endpoint subnet IDs, subresource names, and private DNS zone IDs."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.azure_private_endpoint : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.azure_private_endpoint : try(item.key, "")])) == length(var.azure_private_endpoint)
    error_message = "Each private endpoint item must have a unique non-empty key."
  }
}
