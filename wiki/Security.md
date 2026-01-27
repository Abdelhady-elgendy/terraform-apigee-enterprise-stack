# Security

## IAM

- Use dedicated service accounts for automation.
- Grant least-privilege roles only.
- Use break-glass roles for emergency access.

## KMS/CMEK

- Create KMS key rings and keys for Apigee org and instances.
- Bind IAM roles to allow Apigee to use keys.
- Rotate keys per compliance requirements.

## Audit logs

- Enable audit logging for IAM and API actions.
- Export logs to a central security project.
