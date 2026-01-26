# Stacks vs Modules

This repo is designed so you can run the same platform build in two modes:

1. Terraform Stacks (Terraform Cloud / Terraform Enterprise)
2. Terraform Modules (local CLI runs, GitHub Actions, GitLab CI, etc.)

The core idea:

- Components live in `stacks/apigee-platform/components/*`
- Each component is a valid Terraform module (contains `main.tf`, `variables.tf`, `outputs.tf`)
- Stacks orchestration (ordering, variable wiring, environments) lives in `stacks/*/stack.hcl`

## Mode A: Terraform Stacks (Terraform Cloud / Enterprise)

Stacks are best when you want:

- Centralized orchestration across multiple components
- Environment promotion (dev -> uat -> prod)
- Guardrails and governance at the platform layer
- Standardized inputs and runtime policies

### How to run (high level)

1. Create a Stack in Terraform Cloud/Enterprise.
2. Point it to this repo.
3. Use the platform Stack entrypoint.
   - This repo keeps it at `stacks/apigee-platform/stack.hcl` for clarity.
   - For actual Stack runs, rename to `stack.tfcomponent.hcl` or split into separate `*.tfcomponent.hcl` files.
4. Provide variables for:
   - `project_id`, `region`, `analytics_region`
   - networking inputs (`network_name`, peering range)
   - apigee names (instances, envs, envgroup hostnames)

### Component wiring in the Stack

The platform components have a natural dependency chain:

1. `networking`
2. `org` (depends on service networking connection)
3. `instances` (depends on org)
4. `environments` + `instance_attachment` (depends on instances + envs)
5. `envgroups` + `envgroup_attachment` (depends on envs + envgroups)

Stacks model this dependency chain explicitly and pass outputs as inputs.

### What changes in Terraform Cloud/Enterprise

- Variable sets replace local `*.tfvars`
- Policy sets (OPA/Sentinel) enforce guardrails
- Run tasks enable security scans and approvals
- Stack environments handle promotion and drift detection

## Mode B: Terraform Modules (local runs)

Modules mode is best when you want:

- Simple local development
- CI pipelines that run `terraform plan/apply`
- Reuse inside an existing monorepo or platform repo

### Option 1: Use the examples

```
cd examples/single-region
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
```

### Option 2: Run components directly

You can run components as standalone modules in your own root module:

- `stacks/apigee-platform/components/networking`
- `stacks/apigee-platform/components/org`
- `stacks/apigee-platform/components/instances`
- `stacks/apigee-platform/components/environments`
- `stacks/apigee-platform/components/envgroups`
- `stacks/apigee-platform/components/iam`
- `stacks/apigee-platform/components/kms`

## Which should you choose?

Use Stacks when:

- You have multiple environments (dev/uat/prod)
- Platform engineering owns the build and app teams consume it
- You want stronger governance and standardized rollouts

Use Modules when:

- You are integrating Apigee into an existing Terraform estate
- You prefer CI-driven workflows
- You want to keep everything runnable locally without Terraform Cloud/Enterprise

## Mapping (Stacks -> Modules)

| Concept | Stacks | Modules |
| --- | --- | --- |
| Orchestration | `stack.hcl` defines ordering | Root module defines ordering |
| Environment management | Stack environments | Workspaces / separate state |
| Variable injection | Stack variables / integrations | `*.tfvars`, CI variables |
| Policies | Central guardrails | CI policy checks (OPA/Conftest, Checkov, etc.) |
| State | Managed by TFC/TFE | Local/remote backend as configured |

## Notes for enterprises

- Separate state by blast radius: networking/org vs runtime vs envgroups
- Use workspaces or separate backends per environment
- Add approval gates and drift detection in CI
- Apply policy-as-code in PR checks and apply time
