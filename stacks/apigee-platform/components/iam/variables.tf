variable "project_id" {
  description = "GCP Project ID for the Apigee platform resources."
  type        = string
}

variable "service_accounts" {
  description = "Service accounts to create and their project roles. Map key is account_id."
  type = map(object({
    display_name = optional(string)
    description  = optional(string)
    roles        = optional(list(string))
  }))
  default = {}
}

variable "project_iam_members" {
  description = "Additional project-level IAM members to bind (role/member pairs)."
  type = list(object({
    role   = string
    member = string
  }))
  default = []
}
