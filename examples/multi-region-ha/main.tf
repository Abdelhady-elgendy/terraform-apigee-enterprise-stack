terraform {
  required_version = ">= 1.6.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.30.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.primary_region
}

module "kms" {
  source                 = "../../stacks/apigee-platform/components/kms"
  project_id             = var.project_id
  location               = var.kms_location
  key_ring_name          = var.kms_key_ring_name
  crypto_keys            = var.kms_crypto_keys
  crypto_key_iam_members = var.kms_crypto_key_iam_members
}

module "iam" {
  source              = "../../stacks/apigee-platform/components/iam"
  project_id          = var.project_id
  service_accounts    = var.service_accounts
  project_iam_members = var.project_iam_members
}

module "networking" {
  source                = "../../stacks/apigee-platform/components/networking"
  project_id            = var.project_id
  region                = var.primary_region
  network_name          = var.network_name
  peering_prefix_length = var.peering_prefix_length
  enable_apis           = true
}

module "org" {
  source                               = "../../stacks/apigee-platform/components/org"
  project_id                           = var.project_id
  region                               = var.primary_region
  analytics_region                     = var.analytics_region
  display_name                         = var.org_display_name
  description                          = "Terraform-provisioned Apigee X organization (multi-region HA example)."
  authorized_network                   = module.networking.network_id
  runtime_database_encryption_key_name = try(module.kms.crypto_key_ids[var.kms_org_key_name], null)
  depends_on                           = [module.networking.peering_connection_id]
}

module "instances" {
  source     = "../../stacks/apigee-platform/components/instances"
  project_id = var.project_id
  region     = var.primary_region
  org_id     = module.org.org_id

  instances = {
    (var.primary_instance_name) = {
      location                 = var.primary_region
      peering_cidr_range       = var.instance_peering_cidr_range
      description              = "Primary runtime instance"
      display_name             = var.primary_instance_name
      disk_encryption_key_name = try(module.kms.crypto_key_ids[var.kms_instance_key_name], null)
    }
    (var.secondary_instance_name) = {
      location                 = var.secondary_region
      peering_cidr_range       = var.instance_peering_cidr_range
      description              = "Secondary runtime instance"
      display_name             = var.secondary_instance_name
      disk_encryption_key_name = try(module.kms.crypto_key_ids[var.kms_instance_key_name], null)
    }
  }
}

module "environments" {
  source     = "../../stacks/apigee-platform/components/environments"
  project_id = var.project_id
  region     = var.primary_region
  org_id     = module.org.org_id

  environments = {
    (var.environment_name) = {
      description  = "Production environment"
      display_name = var.environment_name
    }
  }

  instance_attachments = {
    "prod_to_primary" = {
      instance_id = module.instances.instance_ids[var.primary_instance_name]
      environment = var.environment_name
    }
    "prod_to_secondary" = {
      instance_id = module.instances.instance_ids[var.secondary_instance_name]
      environment = var.environment_name
    }
  }
}

module "envgroups" {
  source     = "../../stacks/apigee-platform/components/envgroups"
  project_id = var.project_id
  region     = var.primary_region
  org_id     = module.org.org_id

  envgroups = {
    (var.envgroup_name) = {
      hostnames = var.envgroup_hostnames
    }
  }

  envgroup_attachments = {
    "eg_attach_prod" = {
      envgroup_name = var.envgroup_name
      environment   = var.environment_name
    }
  }
}

output "org_id" { value = module.org.org_id }
output "primary_instance_id" { value = module.instances.instance_ids[var.primary_instance_name] }
output "secondary_instance_id" { value = module.instances.instance_ids[var.secondary_instance_name] }
output "envgroup_id" { value = module.envgroups.envgroup_ids[var.envgroup_name] }
