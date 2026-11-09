locals { gcp_common_labels = merge(var.common_labels, { environment = var.environment }) }

module "gcp_app_engine" {
  source = "./module/app_engine"
  for_each = { for item in var.gcp_app_engine : item.key => item }
  project_id = try(each.value.project_id, var.project_id)
  app_location = try(each.value.app_location, null)
  versions = try(each.value.versions, null)
  depends_on = [module.gcp_project]
}

module "gcp_artifact_registry" {
  source = "./module/artifact_registry"
  for_each = { for item in var.gcp_artifact_registry : item.key => item }
  project_id = try(each.value.project_id, var.project_id)
  name = try(each.value.name, null)
  region = try(each.value.region, null)
  labels = merge(local.gcp_common_labels, try(each.value.labels, {}))
  description = try(each.value.description, null)
  kms_key_name = try(each.value.kms_key_name, null)
  keep_recent_versions = try(each.value.keep_recent_versions, null)
  depends_on = [module.gcp_project]
}

module "gcp_cloud_functions" {
  source = "./module/cloud_functions"
  for_each = { for item in var.gcp_cloud_functions : item.key => item }
  project_id = try(each.value.project_id, var.project_id)
  name = try(each.value.name, null)
  region = try(each.value.region, null)
  labels = merge(local.gcp_common_labels, try(each.value.labels, {}))
  runtime = try(each.value.runtime, null)
  entry_point = try(each.value.entry_point, null)
  source_bucket = try(each.value.source_bucket, null)
  source_object = try(each.value.source_object, null)
  service_account_email = try(each.value.service_account_email, null)
  max_instances = try(each.value.max_instances, null)
  min_instances = try(each.value.min_instances, null)
  memory = try(each.value.memory, null)
  timeout_seconds = try(each.value.timeout_seconds, null)
  ingress_settings = try(each.value.ingress_settings, null)
  depends_on = [module.gcp_project]
}

module "gcp_cloud_run" {
  source = "./module/cloud_run"
  for_each = { for item in var.gcp_cloud_run : item.key => item }
  project_id = try(each.value.project_id, var.project_id)
  name = try(each.value.name, null)
  region = try(each.value.region, null)
  labels = merge(local.gcp_common_labels, try(each.value.labels, {}))
  container_image = try(each.value.container_image, null)
  service_account_email = try(each.value.service_account_email, null)
  ingress = try(each.value.ingress, null)
  min_instances = try(each.value.min_instances, null)
  max_instances = try(each.value.max_instances, null)
  container_port = try(each.value.container_port, null)
  cpu = try(each.value.cpu, null)
  memory = try(each.value.memory, null)
  environment_variables = try(each.value.environment_variables, null)
  deletion_protection = try(each.value.deletion_protection, null)
  depends_on = [module.gcp_project]
}

module "gcp_cloud_sql" {
  source = "./module/cloud_sql"
  for_each = { for item in var.gcp_cloud_sql : item.key => item }
  project_id = try(each.value.project_id, var.project_id)
  name = try(each.value.name, null)
  region = try(each.value.region, null)
  database_version = try(each.value.database_version, null)
  tier = try(each.value.tier, null)
  availability_type = try(each.value.availability_type, null)
  disk_size_gb = try(each.value.disk_size_gb, null)
  backup_retention_count = try(each.value.backup_retention_count, null)
  public_ipv4_enabled = try(each.value.public_ipv4_enabled, null)
  private_network_self_link = try(each.value.private_network_self_link, null)
  deletion_protection = try(each.value.deletion_protection, null)
  labels = merge(local.gcp_common_labels, try(each.value.labels, {}))
  depends_on = [module.gcp_project]
}

module "gcp_cloud_sql_database" {
  source = "./module/cloud_sql_database"
  for_each = { for item in var.gcp_cloud_sql_database : item.key => item }
  project_id = try(each.value.project_id, var.project_id)
  name = try(each.value.name, null)
  instance_name = try(each.value.instance_name, module.gcp_cloud_sql[each.value.instance_key].name)
  charset = try(each.value.charset, null)
  collation = try(each.value.collation, null)
  depends_on = [module.gcp_project]
}

module "gcp_cloud_storage" {
  source = "./module/cloud_storage"
  for_each = { for item in var.gcp_cloud_storage : item.key => item }
  project_id = try(each.value.project_id, var.project_id)
  name = try(each.value.name, null)
  region = try(each.value.region, null)
  labels = merge(local.gcp_common_labels, try(each.value.labels, {}))
  storage_class = try(each.value.storage_class, null)
  kms_key_name = try(each.value.kms_key_name, null)
  retention_period_seconds = try(each.value.retention_period_seconds, null)
  depends_on = [module.gcp_project]
}

module "gcp_eventarc" {
  source = "./module/eventarc"
  for_each = { for item in var.gcp_eventarc : item.key => item }
  project_id = try(each.value.project_id, var.project_id)
  name = try(each.value.name, null)
  region = try(each.value.region, null)
  labels = merge(local.gcp_common_labels, try(each.value.labels, {}))
  service_account_email = try(each.value.service_account_email, null)
  destination_service_name = try(each.value.destination_service_name, null)
  event_type = try(each.value.event_type, null)
  matching_attributes = try(each.value.matching_attributes, null)
  depends_on = [module.gcp_project]
}

module "gcp_firestore" {
  source = "./module/firestore"
  for_each = { for item in var.gcp_firestore : item.key => item }
  project_id = try(each.value.project_id, var.project_id)
  database_name = try(each.value.database_name, null)
  region = try(each.value.region, null)
  point_in_time_recovery_enablement = try(each.value.point_in_time_recovery_enablement, null)
  collection_name = try(each.value.collection_name, null)
  configuration = try(each.value.configuration, null)
  depends_on = [module.gcp_project]
}

module "gcp_gke" {
  source = "./module/gke"
  for_each = { for item in var.gcp_gke : item.key => item }
  project_id = try(each.value.project_id, var.project_id)
  name = try(each.value.name, null)
  region = try(each.value.region, null)
  network_self_link = try(each.value.network_self_link, module.gcp_vpc[each.value.vpc_key].self_link)
  subnetwork_self_link = try(each.value.subnetwork_self_link, module.gcp_subnet[each.value.subnet_key].self_link)
  pods_range_name = try(each.value.pods_range_name, null)
  services_range_name = try(each.value.services_range_name, null)
  private_endpoint = try(each.value.private_endpoint, null)
  master_ipv4_cidr = try(each.value.master_ipv4_cidr, null)
  master_authorized_cidrs = try(each.value.master_authorized_cidrs, null)
  release_channel = try(each.value.release_channel, null)
  deletion_protection = try(each.value.deletion_protection, null)
  min_nodes = try(each.value.min_nodes, null)
  max_nodes = try(each.value.max_nodes, null)
  machine_type = try(each.value.machine_type, null)
  node_service_account_email = try(each.value.node_service_account_email, null)
  disk_size_gb = try(each.value.disk_size_gb, null)
  labels = merge(local.gcp_common_labels, try(each.value.labels, {}))
  depends_on = [module.gcp_project]
}

module "gcp_monitoring" {
  source = "./module/monitoring"
  for_each = { for item in var.gcp_monitoring : item.key => item }
  project_id = try(each.value.project_id, var.project_id)
  region = try(each.value.region, null)
  name_prefix = try(each.value.name_prefix, null)
  environment = try(each.value.environment, null)
  grafana_database_password = var.gcp_monitoring_credentials[each.key].database_password
  grafana_database_tier = try(each.value.grafana_database_tier, null)
  grafana_admin_password = var.gcp_monitoring_credentials[each.key].admin_password
  grafana_invoker_members = try(each.value.grafana_invoker_members, null)
  deletion_protection = try(each.value.deletion_protection, null)
  tags = merge(local.gcp_common_labels, try(each.value.tags, {}))
  depends_on = [module.gcp_project]
}

module "gcp_project" {
  source = "./module/project"
  for_each = { for item in var.gcp_project : item.key => item }
  project_id = try(each.value.project_id, var.project_id)
  create_project = try(each.value.create_project, null)
  display_name = try(each.value.display_name, null)
  organization_id = try(each.value.organization_id, null)
  folder_id = try(each.value.folder_id, null)
  billing_account = try(each.value.billing_account, null)
  labels = merge(local.gcp_common_labels, try(each.value.labels, {}))
}

module "gcp_pubsub" {
  source = "./module/pubsub"
  for_each = { for item in var.gcp_pubsub : item.key => item }
  project_id = try(each.value.project_id, var.project_id)
  name = try(each.value.name, null)
  region = try(each.value.region, null)
  labels = merge(local.gcp_common_labels, try(each.value.labels, {}))
  kms_key_name = try(each.value.kms_key_name, null)
  message_retention_duration = try(each.value.message_retention_duration, null)
  create_subscription = try(each.value.create_subscription, null)
  subscription_name = try(each.value.subscription_name, null)
  ack_deadline_seconds = try(each.value.ack_deadline_seconds, null)
  dead_letter_topic = try(each.value.dead_letter_topic, null)
  max_delivery_attempts = try(each.value.max_delivery_attempts, null)
  depends_on = [module.gcp_project]
}

module "gcp_subnet" {
  source = "./module/subnet"
  for_each = { for item in var.gcp_subnet : item.key => item }
  project_id = try(each.value.project_id, var.project_id)
  name = try(each.value.name, null)
  region = try(each.value.region, null)
  network_self_link = try(each.value.network_self_link, module.gcp_vpc[each.value.vpc_key].self_link)
  ip_cidr_range = try(each.value.ip_cidr_range, null)
  purpose = try(each.value.purpose, null)
  secondary_ip_ranges = try(each.value.secondary_ip_ranges, null)
  depends_on = [module.gcp_project]
}

module "gcp_vpc" {
  source = "./module/vpc"
  for_each = { for item in var.gcp_vpc : item.key => item }
  project_id = try(each.value.project_id, var.project_id)
  name = try(each.value.name, null)
  depends_on = [module.gcp_project]
}

module "gcp_workflows" {
  source = "./module/workflows"
  for_each = { for item in var.gcp_workflows : item.key => item }
  project_id = try(each.value.project_id, var.project_id)
  name = try(each.value.name, null)
  region = try(each.value.region, null)
  labels = merge(local.gcp_common_labels, try(each.value.labels, {}))
  description = try(each.value.description, null)
  service_account_email = try(each.value.service_account_email, null)
  source_contents = try(each.value.source_contents, null)
  depends_on = [module.gcp_project]
}

output "gcp_app_engine_outputs" { description = "Outputs from all app_engine module instances." value = module.gcp_app_engine }

output "gcp_artifact_registry_outputs" { description = "Outputs from all artifact_registry module instances." value = module.gcp_artifact_registry }

output "gcp_cloud_functions_outputs" { description = "Outputs from all cloud_functions module instances." value = module.gcp_cloud_functions }

output "gcp_cloud_run_outputs" { description = "Outputs from all cloud_run module instances." value = module.gcp_cloud_run }

output "gcp_cloud_sql_outputs" { description = "Outputs from all cloud_sql module instances." value = module.gcp_cloud_sql }

output "gcp_cloud_sql_database_outputs" { description = "Outputs from all cloud_sql_database module instances." value = module.gcp_cloud_sql_database }

output "gcp_cloud_storage_outputs" { description = "Outputs from all cloud_storage module instances." value = module.gcp_cloud_storage }

output "gcp_eventarc_outputs" { description = "Outputs from all eventarc module instances." value = module.gcp_eventarc }

output "gcp_firestore_outputs" { description = "Outputs from all firestore module instances." value = module.gcp_firestore }

output "gcp_gke_outputs" { description = "Outputs from all gke module instances." value = module.gcp_gke }

output "gcp_monitoring_outputs" { description = "Outputs from all monitoring module instances." value = module.gcp_monitoring }

output "gcp_project_outputs" { description = "Outputs from all project module instances." value = module.gcp_project }

output "gcp_pubsub_outputs" { description = "Outputs from all pubsub module instances." value = module.gcp_pubsub }

output "gcp_subnet_outputs" { description = "Outputs from all subnet module instances." value = module.gcp_subnet }

output "gcp_vpc_outputs" { description = "Outputs from all vpc module instances." value = module.gcp_vpc }

output "gcp_workflows_outputs" { description = "Outputs from all workflows module instances." value = module.gcp_workflows }
