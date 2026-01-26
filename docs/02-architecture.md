# Architecture

See diagrams in `diagrams/`.

## Recommended enterprise split
- Platform project(s): Apigee org + instances + envgroups
- App projects: env-specific proxies, shared services, DNS, cert automation
- Shared VPC: central network and security controls
