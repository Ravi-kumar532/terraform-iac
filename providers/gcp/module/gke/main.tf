resource "google_container_cluster" "this" {

  project                  = var.project_id
  name                     = var.name
  location                 = var.region
  network                  = var.network_self_link
  subnetwork               = var.subnetwork_self_link
  initial_node_count       = 1
  remove_default_node_pool = true
  deletion_protection      = var.deletion_protection
  resource_labels          = var.labels
  ip_allocation_policy {
    cluster_secondary_range_name  = var.pods_range_name
    services_secondary_range_name = var.services_range_name
  }
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = var.private_endpoint
    master_ipv4_cidr_block  = var.master_ipv4_cidr
  }
  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.master_authorized_cidrs
      content {
        cidr_block   = cidr_blocks.value.cidr
        display_name = cidr_blocks.value.display_name
      }
    }
  }
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
  release_channel {
    channel = var.release_channel
  }

}
resource "google_container_node_pool" "this" {
  project            = var.project_id
  name               = "${var.name}-nodes"
  location           = var.region
  cluster            = google_container_cluster.this.name
  initial_node_count = var.min_nodes
  autoscaling {
    min_node_count = var.min_nodes
    max_node_count = var.max_nodes
  }
  management {
    auto_repair  = true
    auto_upgrade = true
  }
  node_config {
    machine_type    = var.machine_type
    service_account = var.node_service_account_email
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]
    disk_size_gb    = var.disk_size_gb
    disk_type       = "pd-balanced"
    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }
  }
}
