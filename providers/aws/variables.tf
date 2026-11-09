variable "environment" {
  type = string
  validation {
    condition = contains(["dev", "qa", "staging", "prod"], var.environment)
    error_message = "environment must be dev, qa, staging, or prod."
  }
}
variable "region" {
  type = string
  description = "AWS deployment region supplied by the environment."
}
variable "common_tags" {
  type = map(string)
  default = {}
}

variable "aws_app_runner" {
  description = "Typed array of app_runner module instances; every item requires a unique stable key."
  type = list(object({
    key = string
    name = string
    tags = optional(map(string), {

  })
    image_identifier = string
    ecr_access_role_arn = string
    instance_role_arn = optional(string, null)
    port = optional(number, 8080)
    cpu = optional(string, "1 vCPU")
    memory = optional(string, "2 GB")
    publicly_accessible = optional(bool, false)
    environment_variables = optional(map(string), {

  })
    max_concurrency = optional(number, 100)
    min_instances = optional(number, 1)
    max_instances = optional(number, 10)
  }))
  default = []
  validation {
    condition = alltrue([for item in var.aws_app_runner : length(trimspace(item.key)) > 0]) && length(distinct([for item in var.aws_app_runner : item.key])) == length(var.aws_app_runner)
    error_message = "Each aws_app_runner item must have a unique non-empty key."
  }
}

variable "aws_appconfig" {
  description = "Typed array of appconfig module instances; every item requires a unique stable key."
  type = list(object({
    key = string
    name = string
    tags = optional(map(string), {

  })
    description = optional(string, "")
    environment_name = string
    environment_description = optional(string, "")
    configuration_profile_name = string
    configuration = optional(map(string), {})
    deployment_strategy_name = optional(string, "linear-rollout")
    deployment_duration_in_minutes = optional(number, 30)
    deployment_growth_factor = optional(number, 20)
    final_bake_time_in_minutes = optional(number, 10)
  }))
  default = []
  validation {
    condition = alltrue([for item in var.aws_appconfig : length(trimspace(item.key)) > 0]) && length(distinct([for item in var.aws_appconfig : item.key])) == length(var.aws_appconfig)
    error_message = "Each aws_appconfig item must have a unique non-empty key."
  }
}

variable "aws_ecr" {
  description = "Typed array of ecr module instances; every item requires a unique stable key."
  type = list(object({
    key = string
    name = string
    tags = optional(map(string), {

  })
    kms_key_arn = string
    lifecycle_policy = optional(string, "{\"rules\":[{\"rulePriority\":1,\"description\":\"Retain the newest 30 images\",\"selection\":{\"tagStatus\":\"any\",\"countType\":\"imageCountMoreThan\",\"countNumber\":30},\"action\":{\"type\":\"expire\"}}]}")
  }))
  default = []
  validation {
    condition = alltrue([for item in var.aws_ecr : length(trimspace(item.key)) > 0]) && length(distinct([for item in var.aws_ecr : item.key])) == length(var.aws_ecr)
    error_message = "Each aws_ecr item must have a unique non-empty key."
  }
}

variable "aws_eks" {
  description = "Typed array of eks module instances; every item requires a unique stable key."
  type = list(object({
    key = string
    name = string
    cluster_role_arn = string
    kubernetes_version = optional(string, null)
    subnet_ids = optional(list(string))
    endpoint_public_access = optional(bool, false)
    security_group_ids = optional(list(string), [])
    kms_key_arn = string
    tags = optional(map(string), {

  })
    node_role_arn = string
    node_instance_types = optional(list(string), ["m6i.large"])
    node_min_size = optional(number, 2)
    node_desired_size = optional(number, 3)
    node_max_size = optional(number, 8)
    subnet_keys = optional(list(string))
  }))
  default = []
  validation {
    condition = alltrue([for item in var.aws_eks : length(trimspace(item.key)) > 0]) && length(distinct([for item in var.aws_eks : item.key] && alltrue([for item in var.aws_eks : (item.subnet_ids != null && length(item.subnet_ids) > 0) || (length(try(item.subnet_keys, [])) > 0 && alltrue([for subnet_key in try(item.subnet_keys, []) : contains([for subnet in var.aws_subnet : subnet.key], subnet_key)])]))) == length(var.aws_eks)
    error_message = "Each aws_eks item must have a unique non-empty key."
  }
}

variable "aws_elastic_beanstalk" {
  description = "Typed array of elastic_beanstalk module instances; every item requires a unique stable key."
  type = list(object({
    key = string
    name = string
    tags = optional(map(string), {

  })
    description = optional(string, "")
    environment_name = string
    environment_names = optional(list(string), [])
    solution_stack_name = string
    service_role_arn = string
    instance_profile_name = string
    min_instances = optional(number, 2)
    max_instances = optional(number, 6)
    version_label = string
    source_bucket = string
    source_key = string
    load_balancer_scheme = optional(string, "internal")
    certificate_arn = string
  }))
  default = []
  validation {
    condition = alltrue([for item in var.aws_elastic_beanstalk : length(trimspace(item.key)) > 0]) && length(distinct([for item in var.aws_elastic_beanstalk : item.key])) == length(var.aws_elastic_beanstalk)
    error_message = "Each aws_elastic_beanstalk item must have a unique non-empty key."
  }
}

variable "aws_eventbridge" {
  description = "Typed array of eventbridge module instances; every item requires a unique stable key."
  type = list(object({
    key = string
    name = string
    tags = optional(map(string), {

  })
    kms_key_arn = optional(string, null)
  }))
  default = []
  validation {
    condition = alltrue([for item in var.aws_eventbridge : length(trimspace(item.key)) > 0]) && length(distinct([for item in var.aws_eventbridge : item.key])) == length(var.aws_eventbridge)
    error_message = "Each aws_eventbridge item must have a unique non-empty key."
  }
}

variable "aws_lambda" {
  description = "Typed array of lambda module instances; every item requires a unique stable key."
  type = list(object({
    key = string
    name = string
    tags = optional(map(string), {

  })
    execution_role_arn = string
    runtime = optional(string, "python3.12")
    handler = string
    package_bucket = string
    package_key = string
    timeout = optional(number, 30)
    memory_size = optional(number, 512)
    reserved_concurrency = optional(number, 20)
    kms_key_arn = optional(string, null)
    environment_variables = optional(map(string), {

  })
  }))
  default = []
  validation {
    condition = alltrue([for item in var.aws_lambda : length(trimspace(item.key)) > 0]) && length(distinct([for item in var.aws_lambda : item.key])) == length(var.aws_lambda)
    error_message = "Each aws_lambda item must have a unique non-empty key."
  }
}

variable "aws_monitoring" {
  description = "Typed array of monitoring module instances; every item requires a unique stable key."
  type = list(object({
    key = string
    environment = string
    name_prefix = string
    alert_email = optional(string, "")
    db_instance_identifier = string
    tags = optional(map(string), {})
  }))
  default = []
  validation {
    condition = alltrue([for item in var.aws_monitoring : length(trimspace(item.key)) > 0]) && length(distinct([for item in var.aws_monitoring : item.key])) == length(var.aws_monitoring)
    error_message = "Each aws_monitoring item must have a unique non-empty key."
  }
}

variable "aws_rds_mysql" {
  description = "Typed array of rds_mysql module instances; every item requires a unique stable key."
  type = list(object({
    key = string
    name = string
    tags = optional(map(string), {

  })
    engine_version = string
    database_name = string
    instance_class = optional(string, "db.m5.large")
    master_username = string
    allocated_storage = optional(number, 100)
    kms_key_arn = string
    multi_az = optional(bool, true)
    backup_retention_days = optional(number, 14)
    subnet_ids = optional(list(string))
    security_group_ids = list(string)
    subnet_keys = optional(list(string))
  }))
  default = []
  validation {
    condition = alltrue([for item in var.aws_rds_mysql : length(trimspace(item.key)) > 0]) && length(distinct([for item in var.aws_rds_mysql : item.key] && alltrue([for item in var.aws_rds_mysql : (item.subnet_ids != null && length(item.subnet_ids) > 0) || (length(try(item.subnet_keys, [])) > 0 && alltrue([for subnet_key in try(item.subnet_keys, []) : contains([for subnet in var.aws_subnet : subnet.key], subnet_key)])]))) == length(var.aws_rds_mysql)
    error_message = "Each aws_rds_mysql item must have a unique non-empty key."
  }
}

variable "aws_rds_sql_server" {
  description = "Typed array of rds_sql_server module instances; every item requires a unique stable key."
  type = list(object({
    key = string
    name = string
    tags = optional(map(string), {

  })
    engine_version = string
    instance_class = optional(string, "db.m5.large")
    master_username = string
    allocated_storage = optional(number, 100)
    kms_key_arn = string
    multi_az = optional(bool, true)
    backup_retention_days = optional(number, 14)
    subnet_ids = optional(list(string))
    security_group_ids = list(string)
    subnet_keys = optional(list(string))
  }))
  default = []
  validation {
    condition = alltrue([for item in var.aws_rds_sql_server : length(trimspace(item.key)) > 0]) && length(distinct([for item in var.aws_rds_sql_server : item.key] && alltrue([for item in var.aws_rds_sql_server : (item.subnet_ids != null && length(item.subnet_ids) > 0) || (length(try(item.subnet_keys, [])) > 0 && alltrue([for subnet_key in try(item.subnet_keys, []) : contains([for subnet in var.aws_subnet : subnet.key], subnet_key)])]))) == length(var.aws_rds_sql_server)
    error_message = "Each aws_rds_sql_server item must have a unique non-empty key."
  }
}

variable "aws_resource_groups" {
  description = "Typed array of resource_groups module instances; every item requires a unique stable key."
  type = list(object({
    key = string
    name = string
    tag_key = optional(string, "Environment")
    tag_value = string
    tags = optional(map(string), {

  })
  }))
  default = []
  validation {
    condition = alltrue([for item in var.aws_resource_groups : length(trimspace(item.key)) > 0]) && length(distinct([for item in var.aws_resource_groups : item.key])) == length(var.aws_resource_groups)
    error_message = "Each aws_resource_groups item must have a unique non-empty key."
  }
}

variable "aws_s3_bucket" {
  description = "Typed array of s3_bucket module instances; every item requires a unique stable key."
  type = list(object({
    key = string
    name = string
    tags = optional(map(string), {

  })
    kms_key_arn = optional(string, null)
  }))
  default = []
  validation {
    condition = alltrue([for item in var.aws_s3_bucket : length(trimspace(item.key)) > 0]) && length(distinct([for item in var.aws_s3_bucket : item.key])) == length(var.aws_s3_bucket)
    error_message = "Each aws_s3_bucket item must have a unique non-empty key."
  }
}

variable "aws_sqs_sns" {
  description = "Typed array of sqs_sns module instances; every item requires a unique stable key."
  type = list(object({
    key = string
    name = string
    tags = optional(map(string), {

  })
    fifo_queue = optional(bool, false)
    kms_key_arn = optional(string, null)
    message_retention_seconds = optional(number, 1209600)
    visibility_timeout_seconds = optional(number, 60)
    create_topic = optional(bool, true)
    topic_name = optional(string, null)
  }))
  default = []
  validation {
    condition = alltrue([for item in var.aws_sqs_sns : length(trimspace(item.key)) > 0]) && length(distinct([for item in var.aws_sqs_sns : item.key])) == length(var.aws_sqs_sns)
    error_message = "Each aws_sqs_sns item must have a unique non-empty key."
  }
}

variable "aws_step_functions" {
  description = "Typed array of step_functions module instances; every item requires a unique stable key."
  type = list(object({
    key = string
    name = string
    tags = optional(map(string), {

  })
    execution_role_arn = string
    definition = string
    type = optional(string, "STANDARD")
    log_destination = string
  }))
  default = []
  validation {
    condition = alltrue([for item in var.aws_step_functions : length(trimspace(item.key)) > 0]) && length(distinct([for item in var.aws_step_functions : item.key])) == length(var.aws_step_functions)
    error_message = "Each aws_step_functions item must have a unique non-empty key."
  }
}

variable "aws_subnet" {
  description = "Typed array of subnet module instances; every item requires a unique stable key."
  type = list(object({
    key = string
    name = string
    vpc_id = optional(string)
    cidr_block = string
    availability_zone = string
    tags = optional(map(string), {

  })
    vpc_key = optional(string)
  }))
  default = []
  validation {
    condition = alltrue([for item in var.aws_subnet : length(trimspace(item.key)) > 0]) && length(distinct([for item in var.aws_subnet : item.key] && alltrue([for item in var.aws_subnet : item.vpc_id != null || (item.vpc_key != null && contains([for vpc in var.aws_vpc : vpc.key], item.vpc_key))]))) == length(var.aws_subnet)
    error_message = "Each aws_subnet item must have a unique non-empty key."
  }
}

variable "aws_vpc" {
  description = "Typed array of vpc module instances; every item requires a unique stable key."
  type = list(object({
    key = string
    name = string
    cidr_block = string
    tags = optional(map(string), {

  })
  }))
  default = []
  validation {
    condition = alltrue([for item in var.aws_vpc : length(trimspace(item.key)) > 0]) && length(distinct([for item in var.aws_vpc : item.key])) == length(var.aws_vpc)
    error_message = "Each aws_vpc item must have a unique non-empty key."
  }
}
