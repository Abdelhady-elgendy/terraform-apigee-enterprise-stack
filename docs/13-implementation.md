# Implementation Guide (Enterprise)

This guide explains why the stack exists, what each component does, why enterprises adopt this pattern, and the step-by-step implementation flow.

## Why this stack is required

Enterprises adopting Apigee X face the same problems:

- Platform setup is fragmented across scripts, consoles, and partial Terraform examples.
- Networking prerequisites and service networking peering are easy to misconfigure.
- Security teams require least-privilege IAM, auditability, and CMEK where available.
- Platform teams need consistent, repeatable rollouts across dev/test/prod.

This stack addresses those issues by providing a single, opinionated baseline that is:

- Secure-by-default
- Repeatable across environments
- Clear about dependencies and ordering
- Compatible with Stacks or plain Terraform

## What it does (component by component)

### Networking

- Enables required APIs for Apigee and Service Networking.
- Creates a dedicated VPC for Apigee (or can be adapted for Shared VPC).
- Reserves a peering range and establishes the Service Networking connection.

### Apigee Organization

- Creates the Apigee org bound to the GCP project.
- Connects the org to the authorized network (VPC peering) for runtime.
- Optionally sets CMEK for org runtime DB encryption.

### Instances (runtime)

- Creates Apigee runtime instances in one or more regions.
- Optionally configures instance-level CMEK.

### Environments and Attachments

- Creates Apigee environments (dev/test/prod).
- Attaches environments to one or more runtime instances.

### Envgroups and Attachments

- Creates envgroups with hostnames.
- Attaches environments to envgroups to expose APIs.

### IAM

- Creates service accounts used by platform automation.
- Binds project-level roles (least privilege by default).

### KMS (CMEK)

- Creates KMS key ring and crypto keys.
- Optionally binds IAM to allow Apigee to use keys.

## Why enterprises adopt this

- **Compliance:** CMEK support and policy-as-code are mandatory for regulated industries.
- **Governance:** Stacks and CI pipelines centralize approval gates and drift detection.
- **Repeatability:** Standard patterns reduce on-call incidents and migration risk.
- **Security:** Private ingress + least privilege IAM reduces attack surface.

## Step-by-step implementation

### 1) Decide deployment model

- Use **Modules** for local runs and CI pipelines.
- Use **Stacks** for multi-environment orchestration in Terraform Cloud/Enterprise.

### 2) Select an example

Single-region (recommended first):

```
cd examples/single-region
cp terraform.tfvars.example terraform.tfvars
```

Multi-region HA:

```
cd examples/multi-region-ha
cp terraform.tfvars.example terraform.tfvars
```

### 3) Configure required inputs

- `project_id`, `region`, `analytics_region`
- `network_name`, `peering_prefix_length`
- `instance_name` or `primary_instance_name`/`secondary_instance_name`
- `envgroup_hostnames`

Optional (enterprise):

- KMS key ring + crypto keys
- IAM service accounts and project roles

### 4) Run Terraform

```
terraform init
terraform plan
terraform apply
```

### 5) Validate outcomes

- Apigee org exists and is bound to the VPC
- Instances are active in the target regions
- Environments are attached to instances
- Envgroups are created and bound to hostnames

### 6) Extend with runtime stack

- Implement ingress, DNS, and observability in `stacks/runtime/components/*`.
- Attach ingress to envgroups/hostnames.

## Common pitfalls

- Missing APIs (enable `apigee.googleapis.com` and `servicenetworking.googleapis.com`).
- VPC peering range conflicts.
- Missing IAM bindings for CMEK usage.
- Incorrect attachment ordering (envs must exist before attachments).

## Recommended next steps

- Add CI pipelines (GitHub Actions or GitLab) using templates in `ci-templates/`.
- Add policy gates with Conftest/OPA.
- Split state per environment to reduce blast radius.
