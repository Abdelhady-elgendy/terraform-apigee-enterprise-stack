variable "project_id" {
  description = "GCP Project ID for the Apigee platform resources."
  type        = string
}

variable "region" {
  description = "Default region for provider operations."
  type        = string
}

variable "org_id" {
  description = "Apigee org ID in format organizations/{org_name}."
  type        = string
}

variable "instances" {
  description = "Map of Apigee instance definitions keyed by instance name."
  type = map(object({
    location                 = string
    description              = optional(string)
    display_name             = optional(string)
    peering_cidr_range       = optional(string) # e.g., SLASH_22
    ip_range                 = optional(string) # e.g., 10.87.8.0/22
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

variable "labels" {
  description = "Common labels/tags (reserved for future use)."
  type        = map(string)
  default     = {}
}
