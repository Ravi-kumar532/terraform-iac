variable "environment" { type = string; validation { condition = contains(["dev","qa","staging","prod"], var.environment) error_message = "environment must be dev, qa, staging, or prod." } }
variable "project_id" { type = string; description = "Google Cloud project ID." }
variable "region" { type = string; description = "Default Google Cloud region." }
variable "common_labels" { type = map(string); default = {} }
variable "gcp_monitoring_credentials" {
  description = "Grafana credentials injected from a secret manager at deployment time; never commit values."
  type = map(object({ database_password = string, admin_password = string }))
  sensitive = true
  default = {}
}

variable "gcp_app_engine" {
  description = "Array of app_engine module instances; each item requires a unique stable key and module inputs."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.gcp_app_engine : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.gcp_app_engine : try(item.key, "")])) == length(var.gcp_app_engine)
    error_message = "Each gcp_app_engine item must have a unique non-empty key."
  }
}

variable "gcp_artifact_registry" {
  description = "Array of artifact_registry module instances; each item requires a unique stable key and module inputs."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.gcp_artifact_registry : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.gcp_artifact_registry : try(item.key, "")])) == length(var.gcp_artifact_registry)
    error_message = "Each gcp_artifact_registry item must have a unique non-empty key."
  }
}

variable "gcp_cloud_functions" {
  description = "Array of cloud_functions module instances; each item requires a unique stable key and module inputs."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.gcp_cloud_functions : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.gcp_cloud_functions : try(item.key, "")])) == length(var.gcp_cloud_functions)
    error_message = "Each gcp_cloud_functions item must have a unique non-empty key."
  }
}

variable "gcp_cloud_run" {
  description = "Array of cloud_run module instances; each item requires a unique stable key and module inputs."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.gcp_cloud_run : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.gcp_cloud_run : try(item.key, "")])) == length(var.gcp_cloud_run)
    error_message = "Each gcp_cloud_run item must have a unique non-empty key."
  }
}

variable "gcp_cloud_sql" {
  description = "Array of cloud_sql module instances; each item requires a unique stable key and module inputs."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.gcp_cloud_sql : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.gcp_cloud_sql : try(item.key, "")])) == length(var.gcp_cloud_sql)
    error_message = "Each gcp_cloud_sql item must have a unique non-empty key."
  }
}

variable "gcp_cloud_sql_database" {
  description = "Array of cloud_sql_database module instances; each item requires a unique stable key and module inputs."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.gcp_cloud_sql_database : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.gcp_cloud_sql_database : try(item.key, "")])) == length(var.gcp_cloud_sql_database)
    error_message = "Each gcp_cloud_sql_database item must have a unique non-empty key."
  }
}

variable "gcp_cloud_storage" {
  description = "Array of cloud_storage module instances; each item requires a unique stable key and module inputs."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.gcp_cloud_storage : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.gcp_cloud_storage : try(item.key, "")])) == length(var.gcp_cloud_storage)
    error_message = "Each gcp_cloud_storage item must have a unique non-empty key."
  }
}

variable "gcp_eventarc" {
  description = "Array of eventarc module instances; each item requires a unique stable key and module inputs."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.gcp_eventarc : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.gcp_eventarc : try(item.key, "")])) == length(var.gcp_eventarc)
    error_message = "Each gcp_eventarc item must have a unique non-empty key."
  }
}

variable "gcp_firestore" {
  description = "Array of firestore module instances; each item requires a unique stable key and module inputs."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.gcp_firestore : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.gcp_firestore : try(item.key, "")])) == length(var.gcp_firestore)
    error_message = "Each gcp_firestore item must have a unique non-empty key."
  }
}

variable "gcp_gke" {
  description = "Array of gke module instances; each item requires a unique stable key and module inputs."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.gcp_gke : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.gcp_gke : try(item.key, "")])) == length(var.gcp_gke)
    error_message = "Each gcp_gke item must have a unique non-empty key."
  }
}

variable "gcp_monitoring" {
  description = "Array of monitoring module instances; each item requires a unique stable key and module inputs."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.gcp_monitoring : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.gcp_monitoring : try(item.key, "")])) == length(var.gcp_monitoring)
    error_message = "Each gcp_monitoring item must have a unique non-empty key."
  }
}

variable "gcp_project" {
  description = "Array of project module instances; each item requires a unique stable key and module inputs."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.gcp_project : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.gcp_project : try(item.key, "")])) == length(var.gcp_project)
    error_message = "Each gcp_project item must have a unique non-empty key."
  }
}

variable "gcp_pubsub" {
  description = "Array of pubsub module instances; each item requires a unique stable key and module inputs."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.gcp_pubsub : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.gcp_pubsub : try(item.key, "")])) == length(var.gcp_pubsub)
    error_message = "Each gcp_pubsub item must have a unique non-empty key."
  }
}

variable "gcp_subnet" {
  description = "Array of subnet module instances; each item requires a unique stable key and module inputs."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.gcp_subnet : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.gcp_subnet : try(item.key, "")])) == length(var.gcp_subnet)
    error_message = "Each gcp_subnet item must have a unique non-empty key."
  }
}

variable "gcp_vpc" {
  description = "Array of vpc module instances; each item requires a unique stable key and module inputs."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.gcp_vpc : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.gcp_vpc : try(item.key, "")])) == length(var.gcp_vpc)
    error_message = "Each gcp_vpc item must have a unique non-empty key."
  }
}

variable "gcp_workflows" {
  description = "Array of workflows module instances; each item requires a unique stable key and module inputs."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.gcp_workflows : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.gcp_workflows : try(item.key, "")])) == length(var.gcp_workflows)
    error_message = "Each gcp_workflows item must have a unique non-empty key."
  }
}
