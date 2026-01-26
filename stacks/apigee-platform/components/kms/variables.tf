variable "project_id" {
  description = "GCP Project ID for the Apigee platform resources."
  type        = string
}

variable "location" {
  description = "KMS location (e.g., global, us-central1)."
  type        = string
  default     = "global"
}

variable "key_ring_name" {
  description = "Name for the KMS key ring."
  type        = string
  default     = "apigee-kms"
}

variable "crypto_keys" {
  description = "Map of crypto keys to create in the key ring."
  type = map(object({
    purpose                       = optional(string)
    rotation_period               = optional(string)
    labels                        = optional(map(string))
    skip_initial_version_creation = optional(bool)
  }))
  default = {}
}

variable "crypto_key_iam_members" {
  description = "IAM members to bind to crypto keys (role/member pairs)."
  type = list(object({
    key_name = string
    role     = string
    member   = string
  }))
  default = []
}
