# Overview

This project is a production-grade Terraform implementation for Apigee X on Google Cloud. It is opinionated for enterprise use and designed for repeatable, auditable deployments.

## What this stack provides

- Networking prerequisites (VPC, Service Networking, API enablement)
- Apigee org creation with CMEK support where available
- Runtime instances in one or more regions
- Environment and envgroup creation and attachments
- IAM scaffolding for platform automation
- KMS key ring and crypto key scaffolding

## Who should use this

- Platform engineers responsible for standardizing Apigee onboarding
- Security and compliance teams that need CMEK, IAM, and auditability
- Architects implementing multi-environment rollouts

## Deployment modes

- Terraform Stacks (Terraform Cloud/Enterprise) for orchestration and governance
- Terraform Modules for local or CI-driven runs
