# Runbooks

This section provides Day-2 operational guidance for enterprise teams.

## Incident basics

- Define severity levels and escalation paths.
- Maintain contact lists for platform and security owners.
- Keep a simple rollback plan for each change.

## Rollout strategy

- Use canary environments where possible.
- Roll out by environment (dev -> test -> prod).
- Separate state for networking/org vs runtime.

## Certificate lifecycle

- Centralize certificate ownership (PKI or ACME).
- Track expiry dates and renew proactively.
- Automate validation and renewal when possible.

## Change management

- Require change tickets for org/instance changes.
- Apply IAM and KMS changes with approval gates.
- Run `terraform plan` and store artifacts for audit.

## Break-glass access

- Document a break-glass role and workflow.
- Ensure it is audited and time-bound.
