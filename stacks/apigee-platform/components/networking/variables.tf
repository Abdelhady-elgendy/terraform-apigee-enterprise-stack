variable "project_id" {
  description = "GCP Project ID for the Apigee platform resources."
  type        = string
}

variable "region" {
  description = "Default region (used for provider config; networking is global)."
  type        = string
}

variable "network_name" {
  description = "Name for the dedicated Apigee VPC."
  type        = string
  default     = "apigee-vpc"
}

variable "peering_prefix_length" {
  description = "Prefix length for the Service Networking peering range (commonly 16; some deployments use 22)."
  type        = number
  default     = 16
}

variable "enable_apis" {
  description = "If true, enables required Google APIs in the project."
  type        = bool
  default     = true
}

variable "required_services" {
  description = "List of required APIs to enable for the stack."
  type        = list(string)
  default = [
    "apigee.googleapis.com",
    "compute.googleapis.com",
    "servicenetworking.googleapis.com",
  ]
}
