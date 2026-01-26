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

variable "envgroups" {
  description = "Map of envgroups keyed by envgroup name."
  type = map(object({
    hostnames = list(string)
  }))
  default = {
    "prod-eg" = { hostnames = ["api.example.com"] }
  }
}

variable "envgroup_attachments" {
  description = "Map keyed by stable key. Each entry attaches an environment to an envgroup."
  type = map(object({
    envgroup_name = string
    environment   = string
  }))
  default = {}
}

variable "labels" {
  description = "Common labels/tags (reserved for future use)."
  type        = map(string)
  default     = {}
}
