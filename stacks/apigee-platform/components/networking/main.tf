terraform {
  required_version = ">= 1.6.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.30.0"
    }
  }
}


# --- APIs (recommended) ---
resource "google_project_service" "required" {
  for_each           = var.enable_apis ? toset(var.required_services) : toset([])
  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

# --- VPC + Service Networking peering range ---
resource "google_compute_network" "apigee" {
  name                    = var.network_name
  auto_create_subnetworks = false

  depends_on = [google_project_service.required]
}

resource "google_compute_global_address" "peering_range" {
  name          = "${var.network_name}-apigee-peering"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = var.peering_prefix_length
  network       = google_compute_network.apigee.id
}

resource "google_service_networking_connection" "vpc_connection" {
  network                 = google_compute_network.apigee.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.peering_range.name]

  depends_on = [google_project_service.required]
}

output "network_id" {
  description = "VPC network ID used for Apigee authorized_network."
  value       = google_compute_network.apigee.id
}

output "peering_connection_id" {
  description = "Service Networking connection ID."
  value       = google_service_networking_connection.vpc_connection.id
}

output "enabled_services" {
  description = "APIs enabled by this component (if enable_apis=true)."
  value       = var.enable_apis ? tolist(var.required_services) : []
}
