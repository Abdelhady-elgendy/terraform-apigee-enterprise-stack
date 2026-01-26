output "service_account_emails" {
  description = "Map of service account IDs to emails."
  value       = { for k, v in google_service_account.this : k => v.email }
}

output "service_account_ids" {
  description = "Map of service account IDs to resource IDs."
  value       = { for k, v in google_service_account.this : k => v.id }
}
