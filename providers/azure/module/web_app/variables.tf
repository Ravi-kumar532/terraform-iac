variable "apps" {
  description = "Linux Web App definitions; use Key Vault references instead of secret values in app_settings."
  type = list(object({
    name                          = string
    resource_group_name           = string
    location                      = string
    service_plan_id               = string
    public_network_access_enabled = optional(bool, false)
    integration_subnet_id         = optional(string)
    app_settings                  = optional(map(string), {})
    identity_ids                  = optional(list(string), [])
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
    condition = (
      alltrue([
        for app in var.apps :
        length(trimspace(app.name)) > 0 &&
        length(trimspace(app.resource_group_name)) > 0 &&
        length(trimspace(app.location)) > 0 &&
        length(trimspace(app.service_plan_id)) > 0
      ]) &&
      length(distinct([for app in var.apps : lower(app.name)])) == length(var.apps)
    )
    error_message = "Each app must have a unique non-empty name, resource group, location, and service plan ID."
  }
}
