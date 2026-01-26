# Terraform Apigee Enterprise Stack (GCP) - Production-Grade Terraform Stacks Reference Architecture

**terraform-apigee-enterprise-stack** is an opinionated, **enterprise-ready** reference implementation for deploying **Apigee X on Google Cloud (GCP)** using **Terraform Stacks**.  
It gives platform teams a repeatable way to provision **Apigee Org, Instances, Environments, EnvGroups, networking, DNS, IAM, and KMS (CMEK)** with secure-by-default patterns.

> Keywords: Terraform Apigee X, Apigee Terraform, Apigee X Terraform Stack, GCP API Management Terraform, Apigee enterprise architecture, Apigee landing zone, Apigee private ingress, Apigee CMEK, Apigee multi-region HA.

---

## Why this repository exists

Many Apigee Terraform examples are either low-level or incomplete for enterprise rollouts. This stack provides:

- **Terraform Stacks-first** structure for platform engineering and multi-environment workflows
- **Secure-by-default** networking patterns (private ingress, controlled egress, IAM least privilege)
- **Enterprise readiness**: CMEK, logging/monitoring hooks, clear separation of duties, production checklists
- **Battle-tested repo hygiene**: examples, docs, diagrams, changelog, CI scaffolding

---

## What you can deploy

### Apigee control plane (platform)
- Apigee Org (existing Google Cloud Org / project model)
- Apigee X Instances (single region or multi-region)
- Apigee Environments and EnvGroups
- Hostnames + DNS record structure (authoritative DNS external to this repo is supported)

### Enterprise foundations
- Networking patterns for Apigee runtime access (**private ingress** supported)
- **Cloud KMS (CMEK)** for supported resources (where applicable)
- IAM roles and service accounts for platform vs application teams

---

## Architecture diagrams

- **Single-region production**: `diagrams/png/apigee-single-region.png`
- **Multi-region HA**: `diagrams/png/apigee-multi-region-ha.png`
- **CI/CD + Policy**: `diagrams/png/apigee-cicd-policy.png`

Mermaid sources:
- `diagrams/mermaid/apigee-single-region.mmd`
- `diagrams/mermaid/apigee-multi-region-ha.mmd`
- `diagrams/mermaid/apigee-cicd-policy.mmd`

## Docs (MkDocs)

The docs live in `docs/` and can be published with MkDocs.

Local preview:

```
mkdocs serve
```

Deploy to GitHub Pages:

```
mkdocs gh-deploy --force
```

---

## Repository layout

```text
terraform-apigee-enterprise-stack/
├── stacks/
│   ├── apigee-platform/             # Apigee control plane + foundation components
│   │   ├── stack.hcl                 # Terraform Stacks entrypoint
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── components/
│   │       ├── iam/
│   │       ├── kms/
│   │       ├── networking/
│   │       ├── org/
│   │       ├── instances/
│   │       ├── environments/
│   │       └── envgroups/
│   └── runtime/                      # Optional runtime ingress/DNS patterns
│       ├── stack.hcl
│       ├── components/
│       │   ├── ingress/
│       │   ├── dns/
│       │   └── observability/
├── policies/                         # Policy-as-code examples (OPA/Conftest-ready)
├── examples/                         # End-to-end example deployments
├── docs/                             # Enterprise documentation
├── diagrams/                         # Mermaid + PNG diagrams
└── .github/workflows/                # CI scaffolding (fmt, validate, docs)
```

---

## Quickstart (10-15 minutes)

> This repo is designed for **platform engineering teams**. If you are new to Apigee X, start with the docs: `docs/01-overview.md`.

### Prerequisites
- Terraform >= 1.6
- Google Cloud project(s) + permissions
- Apigee API enabled
- A VPC strategy decided (shared VPC recommended for enterprises)

### Steps
1. Clone and enter the repo
2. Copy an example:
   - `examples/single-region/` (recommended first)
3. Populate `terraform.tfvars`
4. Run:
   - `terraform init`
   - `terraform plan`
   - `terraform apply`

> Terraform Stacks workflow depends on your Terraform Stacks runtime (Terraform Cloud/Enterprise, or local stacks toolchain if available in your environment).  
> This repo includes both **Stacks structure** and **plain Terraform module execution** paths.

---

## Production checklist

See: `docs/06-production-checklist.md`

Highlights:
- Enable CMEK where supported
- Separate projects for platform vs app teams
- Centralized logging/monitoring and alerting
- Define hostname strategy and certificate lifecycle
- Adopt policy-as-code and drift detection

---

## Security & compliance

- Least-privilege IAM patterns in `stacks/apigee-platform/components/iam`
- CMEK/KMS scaffolding in `stacks/apigee-platform/components/kms`
- Policy examples in `policies/`

See: `docs/05-security.md`

---

## Examples

- `examples/single-region/` - single region baseline (prod-ready starter)
- `examples/multi-region-ha/` - multi-region HA pattern (active/active-ish routing patterns)

---

## Roadmap

- v1.0: Single-region platform stack + private ingress patterns + docs
- v1.1: Multi-region HA reference + runbooks
- v1.2: GitHub/GitLab CI templates + policy gate examples
- v2.0: Apigee Edge -> X migration helper docs and scripts

---

## Contributing

PRs welcome. Please read `CONTRIBUTING.md` and open an issue for architectural changes.

---

## License

MIT. See `LICENSE`.
