terraform {
  required_version = ">= 1.6.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.30.0"
    }
  }
}

resource "google_kms_key_ring" "this" {
  project  = var.project_id
  name     = var.key_ring_name
  location = var.location
}

resource "google_kms_crypto_key" "this" {
  for_each = var.crypto_keys

  name     = each.key
  key_ring = google_kms_key_ring.this.id
  purpose  = try(each.value.purpose, "ENCRYPT_DECRYPT")

  rotation_period               = try(each.value.rotation_period, null)
  labels                        = try(each.value.labels, null)
  skip_initial_version_creation = try(each.value.skip_initial_version_creation, false)
}

locals {
  crypto_key_iam_members = {
    for idx, item in var.crypto_key_iam_members :
    "${item.key_name}-${replace(item.role, "/", "-")}-${idx}" => item
  }
}

resource "google_kms_crypto_key_iam_member" "this" {
  for_each = local.crypto_key_iam_members

  crypto_key_id = google_kms_crypto_key.this[each.value.key_name].id
  role          = each.value.role
  member        = each.value.member
}
