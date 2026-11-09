variable "project_id" {
  type        = string
  description = "Existing Google Cloud project ID."
}
variable "name" {
  type        = string
  description = "Eventarc trigger name for the native google_eventarc_trigger."
}
variable "region" {
  type        = string
  description = "Google Cloud region."
}
variable "labels" {
  type = map(string)
  default = {

  }
  description = "Resource labels."
}
variable "service_account_email" {
  type        = string
  description = "Caller-provided Eventarc trigger service account; grant event receiver and destination invoker roles."
}
variable "destination_service_name" {
  type        = string
  description = "Existing Cloud Run destination service name."
}
variable "event_type" {
  type        = string
  description = "Eventarc event type, e.g. google.cloud.storage.object.v1.finalized."
}

variable "matching_attributes" {
  type = map(string)
  default = {

  }
  description = "Additional Eventarc event filters (for example bucket=BUCKET_NAME); type is set by event_type."

}
