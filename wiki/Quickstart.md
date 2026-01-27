# Quickstart

This quickstart uses the example configurations provided in the repo.

## Prerequisites

- Terraform >= 1.6
- GCP project with required permissions
- APIs enabled (or allow the networking component to enable them)

## Single-region deployment

```
cd examples/single-region
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
```

## Multi-region deployment

```
cd examples/multi-region-ha
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
```

## Validate

- Apigee org exists and is attached to the VPC
- Instances are active in the target regions
- Environments and envgroups are created and attached
