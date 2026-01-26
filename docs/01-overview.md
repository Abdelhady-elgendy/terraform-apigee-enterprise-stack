# Overview - Apigee X with Terraform Stacks

This repository provides an enterprise reference architecture to deploy **Apigee X** on **Google Cloud** using **Terraform Stacks**.

## What is included
- Platform stack: org/project assumptions, IAM, KMS scaffolding, Apigee instances, environments, envgroups
- Runtime stack: ingress, DNS patterns, observability hooks

## Design principles
- Secure-by-default
- Separation of duties (platform vs application)
- Multi-environment support (dev/test/prod)
- Explicit networking and DNS strategy
