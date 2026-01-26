terraform {
  required_version = ">= 1.6.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.30.0"
    }
  }
}

resource "google_service_account" "this" {
  for_each = var.service_accounts

  account_id   = each.key
  display_name = try(each.value.display_name, null)
  description  = try(each.value.description, null)
}

locals {
  service_account_roles = flatten([
    for sa_name, sa in var.service_accounts : [
      for role in try(sa.roles, []) : {
        sa_name = sa_name
        role    = role
      }
    ]
  ])

  service_account_role_map = {
    for idx, item in local.service_account_roles :
    "${item.sa_name}-${replace(item.role, "/", "-")}-${idx}" => item
  }

  extra_project_members = {
    for idx, item in var.project_iam_members :
    "${replace(item.role, "/", "-")}-${idx}" => item
  }
}

resource "google_project_iam_member" "service_account_roles" {
  for_each = local.service_account_role_map

  project = var.project_id
  role    = each.value.role
  member  = "serviceAccount:${google_service_account.this[each.value.sa_name].email}"
}

resource "google_project_iam_member" "extra" {
  for_each = local.extra_project_members

  project = var.project_id
  role    = each.value.role
  member  = each.value.member
}
