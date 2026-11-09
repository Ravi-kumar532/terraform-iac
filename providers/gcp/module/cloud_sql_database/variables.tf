variable "project_id" {
  type        = string
  description = "Existing Google Cloud project ID."
}
variable "name" {
  type        = string
  description = "Cloud SQL database name for the native google_sql_database resource."
}
variable "instance_name" {
  type        = string
  description = "Existing Cloud SQL instance name."
}
variable "charset" {
  type        = string
  default     = null
  description = "Optional database character set."
}
variable "collation" {
  type        = string
  default     = null
  description = "Optional database collation."
}
