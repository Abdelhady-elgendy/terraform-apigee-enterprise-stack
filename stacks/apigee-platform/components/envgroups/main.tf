terraform {
  required_version = ">= 1.6.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.30.0"
    }
  }
}


# Env Groups
resource "google_apigee_envgroup" "this" {
  for_each = var.envgroups

  org_id    = var.org_id
  name      = each.key
  hostnames = each.value.hostnames

}

# Attach environments to envgroups
resource "google_apigee_envgroup_attachment" "this" {
  for_each = var.envgroup_attachments

  envgroup_id = google_apigee_envgroup.this[each.value.envgroup_name].id
  environment = each.value.environment
}

output "envgroup_ids" {
  description = "Map of envgroup name => envgroup ID."
  value       = { for k, v in google_apigee_envgroup.this : k => v.id }
}

output "envgroup_attachment_ids" {
  description = "Map of attachment key => attachment ID."
  value       = { for k, v in google_apigee_envgroup_attachment.this : k => v.id }
}
