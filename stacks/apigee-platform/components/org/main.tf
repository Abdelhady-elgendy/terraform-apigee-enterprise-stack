terraform {
  required_version = ">= 1.6.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.30.0"
    }
  }
}



# Apigee Organization (top-level container)
resource "google_apigee_organization" "this" {
  project_id          = var.project_id
  analytics_region    = var.analytics_region
  display_name        = var.display_name
  description         = var.description
  authorized_network  = var.disable_vpc_peering ? null : var.authorized_network
  disable_vpc_peering = var.disable_vpc_peering
  runtime_type        = var.runtime_type
  billing_type        = var.billing_type

  # Optional CMEK (paid subscriptions)
  runtime_database_encryption_key_name = var.runtime_database_encryption_key_name

}

output "org_id" {
  description = "Apigee org resource ID in format organizations/{name}."
  value       = google_apigee_organization.this.id
}

output "org_name" {
  description = "Output-only org name."
  value       = google_apigee_organization.this.name
}

output "apigee_project_id" {
  description = "Tenant project ID (output-only)."
  value       = google_apigee_organization.this.apigee_project_id
}
