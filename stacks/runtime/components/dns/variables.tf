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
