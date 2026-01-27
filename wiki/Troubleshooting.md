# Troubleshooting

## API not enabled

- Ensure `apigee.googleapis.com` and `servicenetworking.googleapis.com` are enabled.

## VPC peering errors

- Confirm the peering range is unused.
- Verify Service Networking connection is established.

## CMEK permission errors

- Ensure the Apigee service agent and provisioning identity have KMS permissions.
