# Multi-Environment Strategy

A recommended enterprise layout for dev, test, and prod.

## Folder and project layout

- Org / folder
  - shared-networking
  - apigee-platform-dev
  - apigee-platform-test
  - apigee-platform-prod
  - apigee-runtime-dev
  - apigee-runtime-test
  - apigee-runtime-prod

## Shared VPC model

- Central networking project owns VPC and firewall rules.
- Service projects attach to shared VPC.
- Use a dedicated peering range per environment.

## State separation

- Separate state for networking/org vs runtime.
- Separate state per environment to reduce blast radius.

## Environment promotion

- Promote configuration through dev -> test -> prod.
- Use Terraform Cloud/Enterprise environments or workspace-per-env.
