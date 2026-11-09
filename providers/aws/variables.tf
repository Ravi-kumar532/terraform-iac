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
  description = "Array of app_runner module instances; each item requires a unique stable key and module inputs."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.aws_app_runner : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.aws_app_runner : try(item.key, "")])) == length(var.aws_app_runner)
    error_message = "Each aws_app_runner item must have a unique non-empty key."
  }
}

variable "aws_appconfig" {
  description = "Array of appconfig module instances; each item requires a unique stable key and module inputs."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.aws_appconfig : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.aws_appconfig : try(item.key, "")])) == length(var.aws_appconfig)
    error_message = "Each aws_appconfig item must have a unique non-empty key."
  }
}

variable "aws_ecr" {
  description = "Array of ecr module instances; each item requires a unique stable key and module inputs."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.aws_ecr : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.aws_ecr : try(item.key, "")])) == length(var.aws_ecr)
    error_message = "Each aws_ecr item must have a unique non-empty key."
  }
}

variable "aws_eks" {
  description = "Array of eks module instances; each item requires a unique stable key and module inputs."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.aws_eks : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.aws_eks : try(item.key, "")])) == length(var.aws_eks)
    error_message = "Each aws_eks item must have a unique non-empty key."
  }
}

variable "aws_elastic_beanstalk" {
  description = "Array of elastic_beanstalk module instances; each item requires a unique stable key and module inputs."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.aws_elastic_beanstalk : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.aws_elastic_beanstalk : try(item.key, "")])) == length(var.aws_elastic_beanstalk)
    error_message = "Each aws_elastic_beanstalk item must have a unique non-empty key."
  }
}

variable "aws_eventbridge" {
  description = "Array of eventbridge module instances; each item requires a unique stable key and module inputs."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.aws_eventbridge : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.aws_eventbridge : try(item.key, "")])) == length(var.aws_eventbridge)
    error_message = "Each aws_eventbridge item must have a unique non-empty key."
  }
}

variable "aws_lambda" {
  description = "Array of lambda module instances; each item requires a unique stable key and module inputs."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.aws_lambda : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.aws_lambda : try(item.key, "")])) == length(var.aws_lambda)
    error_message = "Each aws_lambda item must have a unique non-empty key."
  }
}

variable "aws_monitoring" {
  description = "Array of monitoring module instances; each item requires a unique stable key and module inputs."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.aws_monitoring : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.aws_monitoring : try(item.key, "")])) == length(var.aws_monitoring)
    error_message = "Each aws_monitoring item must have a unique non-empty key."
  }
}

variable "aws_rds_mysql" {
  description = "Array of rds_mysql module instances; each item requires a unique stable key and module inputs."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.aws_rds_mysql : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.aws_rds_mysql : try(item.key, "")])) == length(var.aws_rds_mysql)
    error_message = "Each aws_rds_mysql item must have a unique non-empty key."
  }
}

variable "aws_rds_sql_server" {
  description = "Array of rds_sql_server module instances; each item requires a unique stable key and module inputs."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.aws_rds_sql_server : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.aws_rds_sql_server : try(item.key, "")])) == length(var.aws_rds_sql_server)
    error_message = "Each aws_rds_sql_server item must have a unique non-empty key."
  }
}

variable "aws_resource_groups" {
  description = "Array of resource_groups module instances; each item requires a unique stable key and module inputs."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.aws_resource_groups : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.aws_resource_groups : try(item.key, "")])) == length(var.aws_resource_groups)
    error_message = "Each aws_resource_groups item must have a unique non-empty key."
  }
}

variable "aws_s3_bucket" {
  description = "Array of s3_bucket module instances; each item requires a unique stable key and module inputs."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.aws_s3_bucket : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.aws_s3_bucket : try(item.key, "")])) == length(var.aws_s3_bucket)
    error_message = "Each aws_s3_bucket item must have a unique non-empty key."
  }
}

variable "aws_sqs_sns" {
  description = "Array of sqs_sns module instances; each item requires a unique stable key and module inputs."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.aws_sqs_sns : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.aws_sqs_sns : try(item.key, "")])) == length(var.aws_sqs_sns)
    error_message = "Each aws_sqs_sns item must have a unique non-empty key."
  }
}

variable "aws_step_functions" {
  description = "Array of step_functions module instances; each item requires a unique stable key and module inputs."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.aws_step_functions : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.aws_step_functions : try(item.key, "")])) == length(var.aws_step_functions)
    error_message = "Each aws_step_functions item must have a unique non-empty key."
  }
}

variable "aws_subnet" {
  description = "Array of subnet module instances; each item requires a unique stable key and module inputs."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.aws_subnet : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.aws_subnet : try(item.key, "")])) == length(var.aws_subnet)
    error_message = "Each aws_subnet item must have a unique non-empty key."
  }
}

variable "aws_vpc" {
  description = "Array of vpc module instances; each item requires a unique stable key and module inputs."
  type = list(any)
  default = []
  validation {
    condition = alltrue([for item in var.aws_vpc : try(length(trimspace(item.key)) > 0, false)]) && length(distinct([for item in var.aws_vpc : try(item.key, "")])) == length(var.aws_vpc)
    error_message = "Each aws_vpc item must have a unique non-empty key."
  }
}
