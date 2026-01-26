output "key_ring_id" {
  description = "KMS key ring resource ID."
  value       = google_kms_key_ring.this.id
}

output "crypto_key_ids" {
  description = "Map of crypto key name => resource ID."
  value       = { for k, v in google_kms_crypto_key.this : k => v.id }
}

output "crypto_key_names" {
  description = "Map of crypto key name => short name."
  value       = { for k, v in google_kms_crypto_key.this : k => v.name }
}
