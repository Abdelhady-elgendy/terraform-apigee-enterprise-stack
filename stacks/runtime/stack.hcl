// Terraform Stacks component configuration.
// NOTE: Terraform Stacks expects *.tfcomponent.hcl files. Rename to
// stack.tfcomponent.hcl (or split into providers/variables/components files)
// when running in Terraform Cloud/Enterprise.

required_providers {
  google = {
    source  = "hashicorp/google"
    version = ">= 5.30.0"
  }
}

variable "project_id" {
  description = "GCP project ID for runtime resources."
  type        = string
}

variable "region" {
  description = "Region for runtime resources."
  type        = string
}

variable "labels" {
  description = "Common labels/tags."
  type        = map(string)
  default     = {}
}

provider "google" "this" {
  config {
    project = var.project_id
    region  = var.region
  }
}

component "ingress" {
  source = "./components/ingress"
  inputs = {
    project_id = var.project_id
    region     = var.region
    labels     = var.labels
  }
  providers = {
    google = provider.google.this
  }
}

component "dns" {
  source = "./components/dns"
  inputs = {
    project_id = var.project_id
    region     = var.region
    labels     = var.labels
  }
  providers = {
    google = provider.google.this
  }
}

component "observability" {
  source = "./components/observability"
  inputs = {
    project_id = var.project_id
    region     = var.region
    labels     = var.labels
  }
  providers = {
    google = provider.google.this
  }
}
