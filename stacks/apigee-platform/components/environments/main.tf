terraform {
  required_version = ">= 1.6.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.30.0"
    }
  }
}


# Environments
resource "google_apigee_environment" "this" {
  for_each = var.environments

  org_id       = var.org_id
  name         = each.key
  description  = try(each.value.description, null)
  display_name = try(each.value.display_name, null)

}

# Attach environments to runtime instances
resource "google_apigee_instance_attachment" "this" {
  for_each = var.instance_attachments

  instance_id = each.value.instance_id
  environment = each.value.environment

  depends_on = [google_apigee_environment.this]
}

output "environment_names" {
  description = "List of environment names."
  value       = keys(google_apigee_environment.this)
}

output "environment_ids" {
  description = "Map of env name => resource ID."
  value       = { for k, v in google_apigee_environment.this : k => v.id }
}

output "instance_attachment_ids" {
  description = "Map of attachment key => attachment ID."
  value       = { for k, v in google_apigee_instance_attachment.this : k => v.id }
}
