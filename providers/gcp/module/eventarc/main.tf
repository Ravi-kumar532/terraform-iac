resource "google_eventarc_trigger" "this" {
  project         = var.project_id
  name            = var.name
  location        = var.region
  service_account = var.service_account_email
  destination {

    cloud_run_service {
      service = var.destination_service_name
      region  = var.region
    }
  }
  dynamic "matching_criteria" {

    for_each = merge(var.matching_attributes, {
      type = var.event_type
    })
    content {

      attribute = matching_criteria.key
      value     = matching_criteria.value

    }

  }
  labels = var.labels
}
