variable "project_id" {
  type        = string
  description = "Existing Google Cloud project ID."
}
variable "database_name" {
  type        = string
  default     = "(default)"
  description = "Firestore Native database ID for non-secret application configuration; this uses the native google_firestore_database resource."
}
variable "region" {
  type        = string
  description = "Firestore location; immutable after creation. Store non-secret key/value configuration only; IAM access is caller-managed."
}
variable "point_in_time_recovery_enablement" {
  type        = string
  default     = "POINT_IN_TIME_RECOVERY_ENABLED"
  description = "Enable point-in-time recovery for configuration data."
}
variable "collection_name" {
  type        = string
  default     = "application-config"
  description = "Firestore collection containing the application's non-secret configuration documents."
}
variable "configuration" {
  type        = map(string)
  default     = {}
  description = "Non-secret key/value settings written as Firestore documents; values are stored in Terraform state."
}
