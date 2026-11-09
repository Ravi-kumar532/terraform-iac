locals { aws_common_tags = merge(var.common_tags, { Environment = var.environment }) }

module "aws_app_runner" {
  source = "./module/app_runner"
  for_each = { for item in var.aws_app_runner : item.key => item }
  name = try(each.value.name, null)
  tags = merge(local.aws_common_tags, try(each.value.tags, {}))
  image_identifier = try(each.value.image_identifier, null)
  ecr_access_role_arn = try(each.value.ecr_access_role_arn, null)
  instance_role_arn = try(each.value.instance_role_arn, null)
  port = try(each.value.port, null)
  cpu = try(each.value.cpu, null)
  memory = try(each.value.memory, null)
  publicly_accessible = try(each.value.publicly_accessible, null)
  environment_variables = try(each.value.environment_variables, null)
  max_concurrency = try(each.value.max_concurrency, null)
  min_instances = try(each.value.min_instances, null)
  max_instances = try(each.value.max_instances, null)
}

module "aws_appconfig" {
  source = "./module/appconfig"
  for_each = { for item in var.aws_appconfig : item.key => item }
  name = try(each.value.name, null)
  tags = merge(local.aws_common_tags, try(each.value.tags, {}))
  description = try(each.value.description, null)
  environment_name = try(each.value.environment_name, null)
  environment_description = try(each.value.environment_description, null)
  configuration_profile_name = try(each.value.configuration_profile_name, null)
  configuration = try(each.value.configuration, null)
  deployment_strategy_name = try(each.value.deployment_strategy_name, null)
  deployment_duration_in_minutes = try(each.value.deployment_duration_in_minutes, null)
  deployment_growth_factor = try(each.value.deployment_growth_factor, null)
  final_bake_time_in_minutes = try(each.value.final_bake_time_in_minutes, null)
}

module "aws_ecr" {
  source = "./module/ecr"
  for_each = { for item in var.aws_ecr : item.key => item }
  name = try(each.value.name, null)
  tags = merge(local.aws_common_tags, try(each.value.tags, {}))
  kms_key_arn = try(each.value.kms_key_arn, null)
  lifecycle_policy = try(each.value.lifecycle_policy, null)
}

module "aws_eks" {
  source = "./module/eks"
  for_each = { for item in var.aws_eks : item.key => item }
  name = try(each.value.name, null)
  cluster_role_arn = try(each.value.cluster_role_arn, null)
  kubernetes_version = try(each.value.kubernetes_version, null)
  subnet_ids = coalesce(try(each.value.subnet_ids, null), try([for key in each.value.subnet_keys : module.aws_subnet[key].id], []))
  endpoint_public_access = try(each.value.endpoint_public_access, null)
  security_group_ids = try(each.value.security_group_ids, null)
  kms_key_arn = try(each.value.kms_key_arn, null)
  tags = merge(local.aws_common_tags, try(each.value.tags, {}))
  node_role_arn = try(each.value.node_role_arn, null)
  node_instance_types = try(each.value.node_instance_types, null)
  node_min_size = try(each.value.node_min_size, null)
  node_desired_size = try(each.value.node_desired_size, null)
  node_max_size = try(each.value.node_max_size, null)
}

module "aws_elastic_beanstalk" {
  source = "./module/elastic_beanstalk"
  for_each = { for item in var.aws_elastic_beanstalk : item.key => item }
  name = try(each.value.name, null)
  tags = merge(local.aws_common_tags, try(each.value.tags, {}))
  description = try(each.value.description, null)
  environment_name = try(each.value.environment_name, null)
  environment_names = try(each.value.environment_names, null)
  solution_stack_name = try(each.value.solution_stack_name, null)
  service_role_arn = try(each.value.service_role_arn, null)
  instance_profile_name = try(each.value.instance_profile_name, null)
  min_instances = try(each.value.min_instances, null)
  max_instances = try(each.value.max_instances, null)
  version_label = try(each.value.version_label, null)
  source_bucket = try(each.value.source_bucket, null)
  source_key = try(each.value.source_key, null)
  load_balancer_scheme = try(each.value.load_balancer_scheme, null)
  certificate_arn = try(each.value.certificate_arn, null)
}

module "aws_eventbridge" {
  source = "./module/eventbridge"
  for_each = { for item in var.aws_eventbridge : item.key => item }
  name = try(each.value.name, null)
  tags = merge(local.aws_common_tags, try(each.value.tags, {}))
  kms_key_arn = try(each.value.kms_key_arn, null)
}

module "aws_lambda" {
  source = "./module/lambda"
  for_each = { for item in var.aws_lambda : item.key => item }
  name = try(each.value.name, null)
  tags = merge(local.aws_common_tags, try(each.value.tags, {}))
  execution_role_arn = try(each.value.execution_role_arn, null)
  runtime = try(each.value.runtime, null)
  handler = try(each.value.handler, null)
  package_bucket = try(each.value.package_bucket, null)
  package_key = try(each.value.package_key, null)
  timeout = try(each.value.timeout, null)
  memory_size = try(each.value.memory_size, null)
  reserved_concurrency = try(each.value.reserved_concurrency, null)
  kms_key_arn = try(each.value.kms_key_arn, null)
  environment_variables = try(each.value.environment_variables, null)
}

module "aws_monitoring" {
  source = "./module/monitoring"
  for_each = { for item in var.aws_monitoring : item.key => item }
  environment = try(each.value.environment, null)
  name_prefix = try(each.value.name_prefix, null)
  alert_email = try(each.value.alert_email, null)
  db_instance_identifier = try(each.value.db_instance_identifier, null)
  tags = merge(local.aws_common_tags, try(each.value.tags, {}))
}

module "aws_rds_mysql" {
  source = "./module/rds_mysql"
  for_each = { for item in var.aws_rds_mysql : item.key => item }
  name = try(each.value.name, null)
  tags = merge(local.aws_common_tags, try(each.value.tags, {}))
  engine_version = try(each.value.engine_version, null)
  database_name = try(each.value.database_name, null)
  instance_class = try(each.value.instance_class, null)
  master_username = try(each.value.master_username, null)
  allocated_storage = try(each.value.allocated_storage, null)
  kms_key_arn = try(each.value.kms_key_arn, null)
  multi_az = try(each.value.multi_az, null)
  backup_retention_days = try(each.value.backup_retention_days, null)
  subnet_ids = coalesce(try(each.value.subnet_ids, null), try([for key in each.value.subnet_keys : module.aws_subnet[key].id], []))
  security_group_ids = try(each.value.security_group_ids, null)
}

module "aws_rds_sql_server" {
  source = "./module/rds_sql_server"
  for_each = { for item in var.aws_rds_sql_server : item.key => item }
  name = try(each.value.name, null)
  tags = merge(local.aws_common_tags, try(each.value.tags, {}))
  engine_version = try(each.value.engine_version, null)
  instance_class = try(each.value.instance_class, null)
  master_username = try(each.value.master_username, null)
  allocated_storage = try(each.value.allocated_storage, null)
  kms_key_arn = try(each.value.kms_key_arn, null)
  multi_az = try(each.value.multi_az, null)
  backup_retention_days = try(each.value.backup_retention_days, null)
  subnet_ids = coalesce(try(each.value.subnet_ids, null), try([for key in each.value.subnet_keys : module.aws_subnet[key].id], []))
  security_group_ids = try(each.value.security_group_ids, null)
}

module "aws_resource_groups" {
  source = "./module/resource_groups"
  for_each = { for item in var.aws_resource_groups : item.key => item }
  name = try(each.value.name, null)
  tag_key = try(each.value.tag_key, null)
  tag_value = try(each.value.tag_value, null)
  tags = merge(local.aws_common_tags, try(each.value.tags, {}))
}

module "aws_s3_bucket" {
  source = "./module/s3_bucket"
  for_each = { for item in var.aws_s3_bucket : item.key => item }
  name = try(each.value.name, null)
  tags = merge(local.aws_common_tags, try(each.value.tags, {}))
  kms_key_arn = try(each.value.kms_key_arn, null)
}

module "aws_sqs_sns" {
  source = "./module/sqs_sns"
  for_each = { for item in var.aws_sqs_sns : item.key => item }
  name = try(each.value.name, null)
  tags = merge(local.aws_common_tags, try(each.value.tags, {}))
  fifo_queue = try(each.value.fifo_queue, null)
  kms_key_arn = try(each.value.kms_key_arn, null)
  message_retention_seconds = try(each.value.message_retention_seconds, null)
  visibility_timeout_seconds = try(each.value.visibility_timeout_seconds, null)
  create_topic = try(each.value.create_topic, null)
  topic_name = try(each.value.topic_name, null)
}

module "aws_step_functions" {
  source = "./module/step_functions"
  for_each = { for item in var.aws_step_functions : item.key => item }
  name = try(each.value.name, null)
  tags = merge(local.aws_common_tags, try(each.value.tags, {}))
  execution_role_arn = try(each.value.execution_role_arn, null)
  definition = try(each.value.definition, null)
  type = try(each.value.type, null)
  log_destination = try(each.value.log_destination, null)
}

module "aws_subnet" {
  source = "./module/subnet"
  for_each = { for item in var.aws_subnet : item.key => item }
  name = try(each.value.name, null)
  vpc_id = coalesce(try(each.value.vpc_id, null), try(module.aws_vpc[each.value.vpc_key].id, null))
  cidr_block = try(each.value.cidr_block, null)
  availability_zone = try(each.value.availability_zone, null)
  tags = merge(local.aws_common_tags, try(each.value.tags, {}))
}

module "aws_vpc" {
  source = "./module/vpc"
  for_each = { for item in var.aws_vpc : item.key => item }
  name = try(each.value.name, null)
  cidr_block = try(each.value.cidr_block, null)
  tags = merge(local.aws_common_tags, try(each.value.tags, {}))
}

output "aws_app_runner_outputs" {
  description = "Outputs from all app_runner module instances."
  sensitive   = true
  value       = module.aws_app_runner
}

output "aws_appconfig_outputs" {
  description = "Outputs from all appconfig module instances."
  sensitive   = true
  value       = module.aws_appconfig
}

output "aws_ecr_outputs" {
  description = "Outputs from all ecr module instances."
  sensitive   = true
  value       = module.aws_ecr
}

output "aws_eks_outputs" {
  description = "Outputs from all eks module instances."
  sensitive   = true
  value       = module.aws_eks
}

output "aws_elastic_beanstalk_outputs" {
  description = "Outputs from all elastic_beanstalk module instances."
  sensitive   = true
  value       = module.aws_elastic_beanstalk
}

output "aws_eventbridge_outputs" {
  description = "Outputs from all eventbridge module instances."
  sensitive   = true
  value       = module.aws_eventbridge
}

output "aws_lambda_outputs" {
  description = "Outputs from all lambda module instances."
  sensitive   = true
  value       = module.aws_lambda
}

output "aws_monitoring_outputs" {
  description = "Outputs from all monitoring module instances."
  sensitive   = true
  value       = module.aws_monitoring
}

output "aws_rds_mysql_outputs" {
  description = "Outputs from all rds_mysql module instances."
  sensitive   = true
  value       = module.aws_rds_mysql
}

output "aws_rds_sql_server_outputs" {
  description = "Outputs from all rds_sql_server module instances."
  sensitive   = true
  value       = module.aws_rds_sql_server
}

output "aws_resource_groups_outputs" {
  description = "Outputs from all resource_groups module instances."
  sensitive   = true
  value       = module.aws_resource_groups
}

output "aws_s3_bucket_outputs" {
  description = "Outputs from all s3_bucket module instances."
  sensitive   = true
  value       = module.aws_s3_bucket
}

output "aws_sqs_sns_outputs" {
  description = "Outputs from all sqs_sns module instances."
  sensitive   = true
  value       = module.aws_sqs_sns
}

output "aws_step_functions_outputs" {
  description = "Outputs from all step_functions module instances."
  sensitive   = true
  value       = module.aws_step_functions
}

output "aws_subnet_outputs" {
  description = "Outputs from all subnet module instances."
  sensitive   = true
  value       = module.aws_subnet
}

output "aws_vpc_outputs" {
  description = "Outputs from all vpc module instances."
  sensitive   = true
  value       = module.aws_vpc
}
