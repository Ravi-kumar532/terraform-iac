variable "name" {
  type        = string
  description = "RDS SQL Server database instance identifier for the native aws_db_instance; AWS has no standalone SQL Server database resource in the provider."
}
variable "tags" {
  type = map(string)
  default = {

  }
  description = "Resource tags."
}
variable "engine_version" {
  type        = string
  description = "MySQL engine version supported in the target region."
}
variable "database_name" {
  type        = string
  description = "Initial MySQL database name created by RDS."
}
variable "instance_class" {
  type        = string
  default     = "db.m5.large"
  description = "RDS instance class for the SQL database host."
}
variable "master_username" {
  type        = string
  description = "Master login name; RDS manages the password in Secrets Manager."
}
variable "allocated_storage" {
  type        = number
  default     = 100
  description = "Allocated storage in GiB."
}
variable "kms_key_arn" {
  type        = string
  description = "Customer-managed KMS key ARN for encryption."
}
variable "multi_az" {
  type        = bool
  default     = true
  description = "Enable Multi-AZ where supported by SQL Server Standard."
}
variable "backup_retention_days" {
  type        = number
  default     = 14
  description = "Automated backup retention days."
}
variable "subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs spanning at least two availability zones."
  validation {
    condition     = length(distinct(var.subnet_ids)) >= 2
    error_message = "Provide private subnets in at least two availability zones."
  }
}
variable "security_group_ids" {
  type        = list(string)
  description = "Security groups restricting database ingress to approved application clients."
  validation {
    condition     = length(var.security_group_ids) > 0
    error_message = "Provide at least one security group for database ingress control."
  }
}
