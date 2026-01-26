# Troubleshooting

This page lists common failure modes and quick fixes.

## API not enabled

Symptoms:
- Errors about missing `apigee.googleapis.com` or `servicenetworking.googleapis.com`

Fix:
- Ensure APIs are enabled (see `stacks/apigee-platform/components/networking`).
- Re-run `terraform apply` after services are active.

## Service networking connection stuck or failing

Symptoms:
- `google_service_networking_connection` errors
- Apigee org creation fails with VPC peering errors

Fix:
- Confirm the VPC exists and the peering range is unused.
- Check that the project has Service Networking API enabled.
- If the range is already reserved, choose a new `peering_prefix_length` or new VPC name.

## Apigee organization already exists

Symptoms:
- Org creation fails with conflict

Fix:
- Import the org into state or set `disable_vpc_peering = true` if you are attaching to an existing org.
- Use the existing org id in downstream components.

## Instance creation fails

Symptoms:
- Invalid `peering_cidr_range` or `ip_range`
- Region mismatch

Fix:
- Use a valid `peering_cidr_range` enum (for example `SLASH_22`).
- Ensure the instance location matches supported regions for Apigee X.

## Environment or envgroup attachment fails

Symptoms:
- Attachment errors or not found

Fix:
- Ensure envs and envgroups exist before attachments.
- Verify envgroup hostnames are valid and unique.
- If using multiple instances, attach envs to each instance as required.

## CMEK permission errors

Symptoms:
- `Permission denied` when using KMS keys

Fix:
- Grant required IAM to the Apigee service agent and provisioning identity.
- Verify key region matches the resource requirements.

## DNS or hostname mismatch

Symptoms:
- Envgroup hostnames do not resolve

Fix:
- Ensure DNS is managed outside this stack or in the runtime stack.
- Validate certificates and hostname ownership.

## Terraform dependency ordering

Symptoms:
- Resources fail because inputs are not ready

Fix:
- Ensure your root module or Stack orchestrates networking -> org -> instances -> envs -> envgroups.
