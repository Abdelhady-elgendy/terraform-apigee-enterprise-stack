terraform {
  required_version = ">= 1.6.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.30.0"
    }
  }
}



# Apigee runtime instances (data plane)
resource "google_apigee_instance" "this" {
  for_each = var.instances

  org_id   = var.org_id
  name     = each.key
  location = each.value.location

  description              = try(each.value.description, null)
  display_name             = try(each.value.display_name, null)
  peering_cidr_range       = try(each.value.peering_cidr_range, null)
  ip_range                 = try(each.value.ip_range, null)
  disk_encryption_key_name = try(each.value.disk_encryption_key_name, null)
  consumer_accept_list     = try(each.value.consumer_accept_list, null)

}

output "instance_ids" {
  description = "Map of instance name => resource ID (organizations/{org}/instances/{name})."
  value       = { for k, v in google_apigee_instance.this : k => v.id }
}

output "service_attachments" {
  description = "Map of instance name => PSC serviceAttachment (output-only)."
  value       = { for k, v in google_apigee_instance.this : k => v.service_attachment }
}

output "hosts" {
  description = "Map of instance name => exposed host (output-only)."
  value       = { for k, v in google_apigee_instance.this : k => v.host }
}

output "ports" {
  description = "Map of instance name => exposed port (output-only)."
  value       = { for k, v in google_apigee_instance.this : k => v.port }
}
