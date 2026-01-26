variable "project_id" {
  type        = string
  description = "GCP Project ID."
}

variable "region" {
  type        = string
  description = "Apigee instance region (e.g., us-central1)."
  default     = "us-central1"
}

variable "analytics_region" {
  type        = string
  description = "Apigee analytics region."
  default     = "us-central1"
}

variable "network_name" {
  type        = string
  description = "Name of the dedicated Apigee VPC."
  default     = "apigee-vpc"
}

variable "peering_prefix_length" {
  type        = number
  description = "Peering range prefix length."
  default     = 16
}

variable "kms_location" {
  type        = string
  description = "KMS location for key ring (e.g., global, us-central1)."
  default     = "global"
}

variable "kms_key_ring_name" {
  type        = string
  description = "KMS key ring name."
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
  default = {
    "apigee-org-db" = {
      rotation_period = "2592000s"
    }
    "apigee-instance-disk" = {
      rotation_period = "2592000s"
    }
  }
}

variable "kms_crypto_key_iam_members" {
  description = "Optional KMS crypto key IAM bindings."
  type = list(object({
    key_name = string
    role     = string
    member   = string
  }))
  default = []
}

variable "kms_org_key_name" {
  type        = string
  description = "KMS key name for org runtime DB encryption."
  default     = "apigee-org-db"
}

variable "kms_instance_key_name" {
  type        = string
  description = "KMS key name for instance disk encryption."
  default     = "apigee-instance-disk"
}

variable "org_display_name" {
  type        = string
  description = "Apigee organization display name."
  default     = "apigee-org"
}

variable "instance_name" {
  type        = string
  description = "Apigee runtime instance name."
  default     = "apigee-runtime-1"
}

variable "instance_peering_cidr_range" {
  type        = string
  description = "Peering CIDR size enum (e.g., SLASH_22)."
  default     = "SLASH_22"
}

variable "environment_name" {
  type        = string
  description = "Apigee environment name."
  default     = "prod"
}

variable "envgroup_name" {
  type        = string
  description = "Apigee envgroup name."
  default     = "prod-eg"
}

variable "envgroup_hostnames" {
  type        = list(string)
  description = "Hostnames for envgroup."
  default     = ["api.example.com"]
}

variable "service_accounts" {
  description = "Service accounts to create for platform operations."
  type = map(object({
    display_name = optional(string)
    description  = optional(string)
    roles        = optional(list(string))
  }))
  default = {
    "apigee-platform" = {
      display_name = "Apigee Platform Provisioner"
      roles        = ["roles/apigee.admin"]
    }
  }
}

variable "project_iam_members" {
  description = "Additional project-level IAM members to bind."
  type = list(object({
    role   = string
    member = string
  }))
  default = []
}

variable "labels" {
  description = "Common labels/tags."
  type        = map(string)
  default     = {}
}
