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

variable "environments" {
  description = "Map of environment definitions keyed by environment name."
  type = map(object({
    description  = optional(string)
    display_name = optional(string)
  }))
  default = {
    "prod" = { description = "Production", display_name = "prod" }
  }
}

variable "instance_attachments" {
  description = "Map of attachments keyed by any stable key. Each attachment binds an env to an instance."
  type = map(object({
    instance_id = string # organizations/{org}/instances/{instance}
    environment = string # environment name
  }))
  default = {}
}

variable "labels" {
  description = "Common labels/tags (reserved for future use)."
  type        = map(string)
  default     = {}
}
