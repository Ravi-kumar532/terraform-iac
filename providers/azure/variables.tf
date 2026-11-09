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
  description = "Array of sql_database module instances. Each object requires a stable unique key plus the child module inputs."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.azure_sql_database : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.azure_sql_database : try(item.key, "")])) == length(var.azure_sql_database)
    error_message = "Each azure_sql_database item must have a unique non-empty key."
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
  description = "Array of Linux web apps. Each app can list Key Vault keys in key_vaults and optionally override key_vault_role."
  type = list(any)
  default = []
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
