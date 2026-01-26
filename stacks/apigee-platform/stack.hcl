// Terraform Stacks component configuration.
// NOTE: Terraform Stacks expects *.tfcomponent.hcl files. Rename to
// stack.tfcomponent.hcl (or split into providers/variables/components files)
// when running in Terraform Cloud/Enterprise.

required_providers {
  google = {
    source  = "hashicorp/google"
    version = ">= 5.30.0"
  }
}

variable "project_id" {
  description = "GCP project ID for the Apigee platform."
  type        = string
}

variable "region" {
  description = "Primary region for Apigee runtime instances."
  type        = string
}

variable "analytics_region" {
  description = "Region for Apigee analytics data."
  type        = string
  default     = "us-central1"
}

variable "network_name" {
  description = "Name for the dedicated Apigee VPC."
  type        = string
  default     = "apigee-vpc"
}

variable "peering_prefix_length" {
  description = "Prefix length for Service Networking peering range."
  type        = number
  default     = 16
}

variable "enable_apis" {
  description = "Enable required APIs for the platform stack."
  type        = bool
  default     = true
}

variable "org_display_name" {
  description = "Apigee organization display name."
  type        = string
  default     = "apigee-org"
}

variable "org_description" {
  description = "Apigee organization description."
  type        = string
  default     = "Terraform-provisioned Apigee X organization."
}

variable "disable_vpc_peering" {
  description = "Disable VPC peering (only if you do not provide authorized_network)."
  type        = bool
  default     = false
}

variable "runtime_type" {
  description = "Apigee runtime type (e.g., CLOUD)."
  type        = string
  default     = "CLOUD"
}

variable "billing_type" {
  description = "Apigee billing type (optional)."
  type        = string
  default     = null
}

variable "kms_location" {
  description = "KMS location (e.g., global, us-central1)."
  type        = string
  default     = "global"
}

variable "kms_key_ring_name" {
  description = "KMS key ring name."
  type        = string
  default     = "apigee-kms"
}

variable "kms_crypto_keys" {
  description = "KMS crypto keys to create."
  type = map(object({
    purpose                       = optional(string)
    rotation_period               = optional(string)
    labels                        = optional(map(string))
    skip_initial_version_creation = optional(bool)
  }))
  default = {}
}

variable "kms_crypto_key_iam_members" {
  description = "KMS crypto key IAM members."
  type = list(object({
    key_name = string
    role     = string
    member   = string
  }))
  default = []
}

variable "kms_org_key_name" {
  description = "KMS key name for Apigee org runtime database encryption."
  type        = string
  default     = "apigee-org-db"
}

variable "kms_instance_key_name" {
  description = "KMS key name for Apigee instance disk encryption."
  type        = string
  default     = "apigee-instance-disk"
}

variable "service_accounts" {
  description = "Service accounts to create for the platform." 
  type = map(object({
    display_name = optional(string)
    description  = optional(string)
    roles        = optional(list(string))
  }))
  default = {}
}

variable "project_iam_members" {
  description = "Additional project-level IAM role bindings."
  type = list(object({
    role   = string
    member = string
  }))
  default = []
}

variable "instances" {
  description = "Apigee runtime instances keyed by instance name."
  type = map(object({
    location                 = string
    description              = optional(string)
    display_name             = optional(string)
    peering_cidr_range       = optional(string)
    ip_range                 = optional(string)
    disk_encryption_key_name = optional(string)
    consumer_accept_list     = optional(list(string))
  }))
  default = {
    "apigee-runtime-1" = {
      location           = "us-central1"
      peering_cidr_range = "SLASH_22"
    }
  }
}

variable "environments" {
  description = "Apigee environments keyed by environment name."
  type = map(object({
    description  = optional(string)
    display_name = optional(string)
  }))
  default = {
    "prod" = {
      description  = "Production"
      display_name = "prod"
    }
  }
}

variable "instance_attachments" {
  description = "Environment-to-instance attachments."
  type = map(object({
    instance_name = string
    environment   = string
  }))
  default = {}
}

variable "envgroups" {
  description = "Apigee envgroups keyed by envgroup name."
  type = map(object({
    hostnames = list(string)
  }))
  default = {
    "prod-eg" = {
      hostnames = ["api.example.com"]
    }
  }
}

variable "envgroup_attachments" {
  description = "Environment-to-envgroup attachments."
  type = map(object({
    envgroup_name = string
    environment   = string
  }))
  default = {}
}

provider "google" "this" {
  config {
    project = var.project_id
    region  = var.region
  }
}

locals {
  instances = {
    for name, inst in var.instances :
    name => merge(inst, {
      disk_encryption_key_name = try(
        inst.disk_encryption_key_name,
        try(component.kms.crypto_key_ids[var.kms_instance_key_name], null)
      )
    })
  }

  instance_attachments = {
    for key, attachment in var.instance_attachments :
    key => {
      instance_id = component.instances.instance_ids[attachment.instance_name]
      environment = attachment.environment
    }
  }

  envgroup_attachments = {
    for key, attachment in var.envgroup_attachments :
    key => {
      envgroup_name = attachment.envgroup_name
      environment   = attachment.environment
    }
  }
}

component "networking" {
  source = "./components/networking"
  inputs = {
    project_id            = var.project_id
    region                = var.region
    network_name          = var.network_name
    peering_prefix_length = var.peering_prefix_length
    enable_apis           = var.enable_apis
  }
  providers = {
    google = provider.google.this
  }
}

component "kms" {
  source = "./components/kms"
  inputs = {
    project_id            = var.project_id
    location              = var.kms_location
    key_ring_name         = var.kms_key_ring_name
    crypto_keys           = var.kms_crypto_keys
    crypto_key_iam_members = var.kms_crypto_key_iam_members
  }
  providers = {
    google = provider.google.this
  }
}

component "iam" {
  source = "./components/iam"
  inputs = {
    project_id          = var.project_id
    service_accounts    = var.service_accounts
    project_iam_members = var.project_iam_members
  }
  providers = {
    google = provider.google.this
  }
}

component "org" {
  source = "./components/org"
  inputs = {
    project_id       = var.project_id
    region           = var.region
    analytics_region = var.analytics_region
    display_name     = var.org_display_name
    description      = var.org_description

    authorized_network  = var.disable_vpc_peering ? null : component.networking.network_id
    disable_vpc_peering = var.disable_vpc_peering

    runtime_type  = var.runtime_type
    billing_type  = var.billing_type
    runtime_database_encryption_key_name = try(
      component.kms.crypto_key_ids[var.kms_org_key_name],
      null
    )
  }
  providers = {
    google = provider.google.this
  }
}

component "instances" {
  source = "./components/instances"
  inputs = {
    project_id = var.project_id
    region     = var.region
    org_id     = component.org.org_id
    instances  = local.instances
  }
  providers = {
    google = provider.google.this
  }
}

component "environments" {
  source = "./components/environments"
  inputs = {
    project_id          = var.project_id
    region              = var.region
    org_id              = component.org.org_id
    environments        = var.environments
    instance_attachments = local.instance_attachments
  }
  providers = {
    google = provider.google.this
  }
}

component "envgroups" {
  source = "./components/envgroups"
  inputs = {
    project_id           = var.project_id
    region               = var.region
    org_id               = component.org.org_id
    envgroups            = var.envgroups
    envgroup_attachments = local.envgroup_attachments
  }
  providers = {
    google = provider.google.this
  }
}

output "network_id" {
  value = component.networking.network_id
}

output "org_id" {
  value = component.org.org_id
}

output "instance_ids" {
  value = component.instances.instance_ids
}

output "environment_ids" {
  value = component.environments.environment_ids
}

output "envgroup_ids" {
  value = component.envgroups.envgroup_ids
}

output "crypto_key_ids" {
  value = component.kms.crypto_key_ids
}

output "service_account_emails" {
  value = component.iam.service_account_emails
}
