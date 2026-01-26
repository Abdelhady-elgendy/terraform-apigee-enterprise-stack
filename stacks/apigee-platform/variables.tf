variable "project_id" {
  description = "GCP Project ID for the Apigee platform resources."
  type        = string
}

variable "region" {
  description = "Primary region for Apigee instance (e.g., us-central1, europe-west2)."
  type        = string
}

variable "labels" {
  description = "Common labels/tags."
  type        = map(string)
  default     = {}
}

variable "apigee_org_id" {
  description = "Apigee organization ID (often same as project, depending on setup)."
  type        = string
}

variable "envs" {
  description = "Apigee environments to create (e.g., [dev, test, prod])."
  type        = list(string)
  default     = ["dev"]
}

variable "instance_name" {
  description = "Apigee instance name."
  type        = string
  default     = "apigee-x-01"
}
