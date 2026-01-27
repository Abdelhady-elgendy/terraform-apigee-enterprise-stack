---
title: "Terraform Apigee Enterprise Stack"
description: "Production-grade Terraform Stacks + Modules for deploying Apigee X on Google Cloud (GCP) with enterprise documentation, security guardrails, and reference architectures."
---

# Terraform Apigee Enterprise Stack (GCP - Apigee X)

Welcome
This repository is a production-grade, enterprise-friendly Terraform implementation to deploy Apigee X on Google Cloud using reusable components that can run in:

- Terraform Stacks (Terraform Cloud / Terraform Enterprise) for orchestration and governance
- Terraform Modules (local runs / CI pipelines) for maximum portability

If you are evaluating Apigee X for API management, this repo focuses on Day-0 platform foundations: org, runtime instances, environments, envgroups, attachments, and networking prerequisites.

## Documentation IA

Start here:

- [Overview](01-overview.md)
- [Architecture](02-architecture.md)
- [Quickstart](03-quickstart.md)
- [Stacks vs Modules](04-stacks-vs-modules.md)
- [Security](05-security.md)
- [Production Readiness Checklist](06-production-checklist.md)
- [Troubleshooting](07-troubleshooting.md)

Day-2 guides:

- [Runbooks](08-runbooks.md)
- [Cost and Sizing](09-cost.md)
- [Multi-Environment Strategy](10-multi-env.md)
- [Security Posture](11-security-posture.md)
- [CI/CD Templates](12-ci-cd.md)
- [Implementation Guide](13-implementation.md)

## Reference architectures

- [Single-region production baseline](../examples/single-region/README.md)
- [Multi-region HA blueprint](../examples/multi-region-ha/README.md)

## Diagrams

- Mermaid sources: [`/diagrams/mermaid`](../diagrams/mermaid)

## What gets deployed (core)

Using the Google Terraform provider resources:

- Apigee Organization: `google_apigee_organization`
- Apigee Runtime Instance: `google_apigee_instance`
- Environments: `google_apigee_environment`
- Env Groups: `google_apigee_envgroup`
- Attachments:
  - Environment -> Instance: `google_apigee_instance_attachment`
  - Environment -> Envgroup: `google_apigee_envgroup_attachment`

See the component implementations under `stacks/apigee-platform/components/*`.

## Publish docs (GitHub Pages)

This repo ships a minimal `mkdocs.yml` to publish `/docs`.

Example (local preview):

```
mkdocs serve
```

Example (deploy to GitHub Pages):

```
mkdocs gh-deploy --force
```
