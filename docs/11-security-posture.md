# Security Posture

Guidance for a secure-by-default Apigee platform deployment.

## Private ingress patterns

- Prefer private ingress with PSC and internal load balancers.
- Restrict inbound access to approved IP ranges.
- Separate runtime ingress from platform resources.

## IAM and least privilege

- Use dedicated service accounts for provisioning vs runtime.
- Bind only required roles to each identity.
- Use break-glass access for emergency changes.

## Audit logging

- Enable audit logs for IAM and API changes.
- Export logs to a central security project.

## Policy gates

- Enforce terraform fmt, validate, and security checks in CI.
- Use OPA/Conftest or policy sets for guardrails.

## CMEK and data protection

- Use KMS keys for supported Apigee resources.
- Rotate keys based on your compliance policy.
