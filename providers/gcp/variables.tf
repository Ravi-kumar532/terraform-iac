variable "environment" {
  type = string
  validation {
    condition = contains(["dev", "qa", "staging", "prod"], var.environment)
    error_message = "environment must be dev, qa, staging, or prod."
  }
}
variable "project_id" {
  type = string
  description = "Google Cloud project ID."
}
variable "region" {
  type = string
  description = "Default Google Cloud region."
}
variable "common_labels" {
  type = map(string)
  default = {}
}
variable "gcp_monitoring_credentials" {
  description = "Grafana credentials injected from a secret manager at deployment time; never commit values."
  type = map(object({ database_password = string, admin_password = string }))
  sensitive = true
  default = {}
}

variable "gcp_app_engine" {
  description = "Typed array of app_engine module instances; every item requires a unique stable key."
  type = list(object({
    key = string
    project_id = optional(string, null)
    app_location = optional(string, "us-central")
    versions = optional(map(object({
    service_name          = string
    version_id            = string
    runtime               = string
    entrypoint_command    = string
    service_account       = string
    source_archive_url    = string
    instance_class        = optional(string, "F2")
    environment_variables = optional(map(string), {})
    min_instances         = optional(number, 1)
    max_instances         = optional(number, 10)
  })), {})
  }))
  default = []
  validation {
    condition = alltrue([for item in var.gcp_app_engine : length(trimspace(item.key)) > 0]) && length(distinct([for item in var.gcp_app_engine : item.key])) == length(var.gcp_app_engine)
    error_message = "Each gcp_app_engine item must have a unique non-empty key."
  }
}

variable "gcp_artifact_registry" {
  description = "Typed array of artifact_registry module instances; every item requires a unique stable key."
  type = list(object({
    key = string
    project_id = optional(string, null)
    name = string
    region = optional(string, null)
    labels = optional(map(string), {

  })
    description = optional(string, "")
    kms_key_name = optional(string, null)
    keep_recent_versions = optional(number, 30)
  }))
  default = []
  validation {
    condition = alltrue([for item in var.gcp_artifact_registry : length(trimspace(item.key)) > 0]) && length(distinct([for item in var.gcp_artifact_registry : item.key])) == length(var.gcp_artifact_registry)
    error_message = "Each gcp_artifact_registry item must have a unique non-empty key."
  }
}

variable "gcp_cloud_functions" {
  description = "Typed array of cloud_functions module instances; every item requires a unique stable key."
  type = list(object({
    key = string
    project_id = optional(string, null)
    name = string
    region = optional(string, null)
    labels = optional(map(string), {

  })
    runtime = optional(string, "python312")
    entry_point = string
    source_bucket = string
    source_object = string
    service_account_email = string
    max_instances = optional(number, 10)
    min_instances = optional(number, 1)
    memory = optional(string, "512M")
    timeout_seconds = optional(number, 60)
    ingress_settings = optional(string, "ALLOW_INTERNAL_ONLY")
  }))
  default = []
  validation {
    condition = alltrue([for item in var.gcp_cloud_functions : length(trimspace(item.key)) > 0]) && length(distinct([for item in var.gcp_cloud_functions : item.key])) == length(var.gcp_cloud_functions)
    error_message = "Each gcp_cloud_functions item must have a unique non-empty key."
  }
}

variable "gcp_cloud_run" {
  description = "Typed array of cloud_run module instances; every item requires a unique stable key."
  type = list(object({
    key = string
    project_id = optional(string, null)
    name = string
    region = optional(string, null)
    labels = optional(map(string), {

  })
    container_image = string
    service_account_email = string
    ingress = optional(string, "INGRESS_TRAFFIC_INTERNAL_ONLY")
    min_instances = optional(number, 1)
    max_instances = optional(number, 10)
    container_port = optional(number, 8080)
    cpu = optional(string, "1")
    memory = optional(string, "512Mi")
    environment_variables = optional(map(string), {

  })
    deletion_protection = optional(bool, true)
  }))
  default = []
  validation {
    condition = alltrue([for item in var.gcp_cloud_run : length(trimspace(item.key)) > 0]) && length(distinct([for item in var.gcp_cloud_run : item.key])) == length(var.gcp_cloud_run)
    error_message = "Each gcp_cloud_run item must have a unique non-empty key."
  }
}

variable "gcp_cloud_sql" {
  description = "Typed array of cloud_sql module instances; every item requires a unique stable key."
  type = list(object({
    key = string
    project_id = optional(string, null)
    name = string
    region = optional(string, null)
    database_version = optional(string, "POSTGRES_16")
    tier = optional(string, "db-custom-2-7680")
    availability_type = optional(string, "REGIONAL")
    disk_size_gb = optional(number, 100)
    backup_retention_count = optional(number, 14)
    public_ipv4_enabled = optional(bool, false)
    private_network_self_link = optional(string, null)
    deletion_protection = optional(bool, true)
    labels = optional(map(string), {

  })
  }))
  default = []
  validation {
    condition = alltrue([for item in var.gcp_cloud_sql : length(trimspace(item.key)) > 0]) && length(distinct([for item in var.gcp_cloud_sql : item.key])) == length(var.gcp_cloud_sql)
    error_message = "Each gcp_cloud_sql item must have a unique non-empty key."
  }
}

variable "gcp_cloud_sql_database" {
  description = "Typed array of cloud_sql_database module instances; every item requires a unique stable key."
  type = list(object({
    key = string
    project_id = optional(string, null)
    name = string
    instance_name = optional(string, null)
    charset = optional(string, null)
    collation = optional(string, null)
    instance_key = optional(string)
  }))
  default = []
  validation {
    condition = alltrue([for item in var.gcp_cloud_sql_database : length(trimspace(item.key)) > 0]) && length(distinct([for item in var.gcp_cloud_sql_database : item.key])) == length(var.gcp_cloud_sql_database)
    error_message = "Each gcp_cloud_sql_database item must have a unique non-empty key."
  }
}

variable "gcp_cloud_storage" {
  description = "Typed array of cloud_storage module instances; every item requires a unique stable key."
  type = list(object({
    key = string
    project_id = optional(string, null)
    name = string
    region = optional(string, null)
    labels = optional(map(string), {

  })
    storage_class = optional(string, "STANDARD")
    kms_key_name = optional(string, null)
    retention_period_seconds = optional(number, null)
  }))
  default = []
  validation {
    condition = alltrue([for item in var.gcp_cloud_storage : length(trimspace(item.key)) > 0]) && length(distinct([for item in var.gcp_cloud_storage : item.key])) == length(var.gcp_cloud_storage)
    error_message = "Each gcp_cloud_storage item must have a unique non-empty key."
  }
}

variable "gcp_eventarc" {
  description = "Typed array of eventarc module instances; every item requires a unique stable key."
  type = list(object({
    key = string
    project_id = optional(string, null)
    name = string
    region = optional(string, null)
    labels = optional(map(string), {

  })
    service_account_email = string
    destination_service_name = string
    event_type = string
    matching_attributes = optional(map(string), {

  })
  }))
  default = []
  validation {
    condition = alltrue([for item in var.gcp_eventarc : length(trimspace(item.key)) > 0]) && length(distinct([for item in var.gcp_eventarc : item.key])) == length(var.gcp_eventarc)
    error_message = "Each gcp_eventarc item must have a unique non-empty key."
  }
}

variable "gcp_firestore" {
  description = "Typed array of firestore module instances; every item requires a unique stable key."
  type = list(object({
    key = string
    project_id = optional(string, null)
    database_name = optional(string, "(default)")
    region = optional(string, null)
    point_in_time_recovery_enablement = optional(string, "POINT_IN_TIME_RECOVERY_ENABLED")
    collection_name = optional(string, "application-config")
    configuration = optional(map(string), {})
  }))
  default = []
  validation {
    condition = alltrue([for item in var.gcp_firestore : length(trimspace(item.key)) > 0]) && length(distinct([for item in var.gcp_firestore : item.key])) == length(var.gcp_firestore)
    error_message = "Each gcp_firestore item must have a unique non-empty key."
  }
}

variable "gcp_gke" {
  description = "Typed array of gke module instances; every item requires a unique stable key."
  type = list(object({
    key = string
    project_id = optional(string, null)
    name = string
    region = optional(string, null)
    network_self_link = optional(string, null)
    subnetwork_self_link = optional(string, null)
    pods_range_name = string
    services_range_name = string
    private_endpoint = optional(bool, true)
    master_ipv4_cidr = string
    master_authorized_cidrs = optional(list(object({
    display_name = string
    cidr         = string
  })), [])
    release_channel = optional(string, "REGULAR")
    deletion_protection = optional(bool, true)
    min_nodes = optional(number, 1)
    max_nodes = optional(number, 5)
    machine_type = optional(string, "e2-standard-4")
    node_service_account_email = string
    disk_size_gb = optional(number, 100)
    labels = optional(map(string), {

  })
    vpc_key = optional(string)
    subnet_key = optional(string)
  }))
  default = []
  validation {
    condition = alltrue([for item in var.gcp_gke : length(trimspace(item.key)) > 0]) && length(distinct([for item in var.gcp_gke : item.key])) == length(var.gcp_gke)
    error_message = "Each gcp_gke item must have a unique non-empty key."
  }
}

variable "gcp_monitoring" {
  description = "Typed array of monitoring module instances; every item requires a unique stable key."
  type = list(object({
    key = string
    project_id = optional(string, null)
    region = optional(string, null)
    name_prefix = string
    environment = string
    grafana_database_tier = string
    grafana_invoker_members = list(string)
    deletion_protection = optional(bool, true)
    tags = optional(map(string), {})
  }))
  default = []
  validation {
    condition = alltrue([for item in var.gcp_monitoring : length(trimspace(item.key)) > 0]) && length(distinct([for item in var.gcp_monitoring : item.key])) == length(var.gcp_monitoring)
    error_message = "Each gcp_monitoring item must have a unique non-empty key."
  }
}

variable "gcp_project" {
  description = "Typed array of project module instances; every item requires a unique stable key."
  type = list(object({
    key = string
    project_id = optional(string, null)
    create_project = optional(bool, false)
    display_name = optional(string, null)
    organization_id = optional(string, null)
    folder_id = optional(string, null)
    billing_account = optional(string, null)
    labels = optional(map(string), {

  })
  }))
  default = []
  validation {
    condition = alltrue([for item in var.gcp_project : length(trimspace(item.key)) > 0]) && length(distinct([for item in var.gcp_project : item.key])) == length(var.gcp_project)
    error_message = "Each gcp_project item must have a unique non-empty key."
  }
}

variable "gcp_pubsub" {
  description = "Typed array of pubsub module instances; every item requires a unique stable key."
  type = list(object({
    key = string
    project_id = optional(string, null)
    name = string
    region = optional(string, null)
    labels = optional(map(string), {

  })
    kms_key_name = optional(string, null)
    message_retention_duration = optional(string, "1209600s")
    create_subscription = optional(bool, true)
    subscription_name = optional(string, null)
    ack_deadline_seconds = optional(number, 60)
    dead_letter_topic = optional(string, null)
    max_delivery_attempts = optional(number, 5)
  }))
  default = []
  validation {
    condition = alltrue([for item in var.gcp_pubsub : length(trimspace(item.key)) > 0]) && length(distinct([for item in var.gcp_pubsub : item.key])) == length(var.gcp_pubsub)
    error_message = "Each gcp_pubsub item must have a unique non-empty key."
  }
}

variable "gcp_subnet" {
  description = "Typed array of subnet module instances; every item requires a unique stable key."
  type = list(object({
    key = string
    project_id = optional(string, null)
    name = string
    region = optional(string, null)
    network_self_link = optional(string, null)
    ip_cidr_range = string
    purpose = optional(string, null)
    secondary_ip_ranges = optional(list(object({
    range_name    = string
    ip_cidr_range = string
  })), [])
    vpc_key = optional(string)
  }))
  default = []
  validation {
    condition = alltrue([for item in var.gcp_subnet : length(trimspace(item.key)) > 0]) && length(distinct([for item in var.gcp_subnet : item.key])) == length(var.gcp_subnet)
    error_message = "Each gcp_subnet item must have a unique non-empty key."
  }
}

variable "gcp_vpc" {
  description = "Typed array of vpc module instances; every item requires a unique stable key."
  type = list(object({
    key = string
    project_id = optional(string, null)
    name = string
  }))
  default = []
  validation {
    condition = alltrue([for item in var.gcp_vpc : length(trimspace(item.key)) > 0]) && length(distinct([for item in var.gcp_vpc : item.key])) == length(var.gcp_vpc)
    error_message = "Each gcp_vpc item must have a unique non-empty key."
  }
}

variable "gcp_workflows" {
  description = "Typed array of workflows module instances; every item requires a unique stable key."
  type = list(object({
    key = string
    project_id = optional(string, null)
    name = string
    region = optional(string, null)
    labels = optional(map(string), {

  })
    description = optional(string, "")
    service_account_email = string
    source_contents = string
  }))
  default = []
  validation {
    condition = alltrue([for item in var.gcp_workflows : length(trimspace(item.key)) > 0]) && length(distinct([for item in var.gcp_workflows : item.key])) == length(var.gcp_workflows)
    error_message = "Each gcp_workflows item must have a unique non-empty key."
  }
}
