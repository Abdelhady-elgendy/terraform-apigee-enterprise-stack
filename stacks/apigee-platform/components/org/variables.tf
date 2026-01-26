variable "project_id" {
  description = "GCP Project ID associated with the Apigee organization."
  type        = string
}

variable "region" {
  description = "Default region for provider operations."
  type        = string
}

variable "analytics_region" {
  description = "Primary region for analytics data storage (e.g., us-central1)."
  type        = string
  default     = "us-central1"
}

variable "display_name" {
  description = "Display name for the Apigee organization."
  type        = string
  default     = null
}

variable "description" {
  description = "Description for the Apigee organization."
  type        = string
  default     = null
}

variable "authorized_network" {
  description = "VPC network (self_link or id) used for Service Networking peering with Apigee runtime instances."
  type        = string
  default     = null
}

variable "disable_vpc_peering" {
  description = "Set true to disable VPC peering (only if you do not provide authorized_network). Must be set before instances exist."
  type        = bool
  default     = false
}

variable "runtime_type" {
  description = "Runtime type of the org. Default CLOUD."
  type        = string
  default     = "CLOUD"
}

variable "billing_type" {
  description = "Billing type (Apigee pricing)."
  type        = string
  default     = null
}

variable "runtime_database_encryption_key_name" {
  description = "Optional CMEK for runtime database encryption (paid subscriptions only)."
  type        = string
  default     = null
}
