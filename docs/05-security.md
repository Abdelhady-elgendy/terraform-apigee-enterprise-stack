# Security

## IAM
- Separate SA for provisioning vs runtime
- Principle of least privilege

## CMEK
Use `components/kms` and wire keys into supported resources.

## Policy-as-code
See `policies/` for example rules (OPA/Conftest-style).
