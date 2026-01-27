# Stacks vs Modules

This repo supports both Terraform Stacks and Terraform Modules.

## When to use Stacks

- Multi-environment promotion (dev/test/prod)
- Centralized governance and policy enforcement
- Standardized orchestration of multiple components

## When to use Modules

- Local development or CI pipelines
- Integration into existing Terraform codebases
- Simpler workflows without Terraform Cloud/Enterprise

## How to run in Stacks

- Use `stacks/apigee-platform/stack.hcl` as the component configuration.
- Rename to `stack.tfcomponent.hcl` for Terraform Cloud/Enterprise.
- Provide variables for project, region, and networking inputs.

## How to run in Modules

- Use the examples in `examples/`.
- Or compose the components directly in your root module.
