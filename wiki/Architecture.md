# Architecture

## Core platform components

- Networking: VPC + Service Networking peering range
- Apigee Organization: top-level container
- Apigee Instances: runtime instances per region
- Environments: dev/test/prod
- EnvGroups: hostnames mapped to environments

## Dependency ordering

1. Networking and API enablement
2. Apigee Organization
3. Apigee Instances
4. Environments and instance attachments
5. EnvGroups and envgroup attachments

## Reference diagrams

See the Mermaid diagrams in the main repo:

- `diagrams/mermaid/apigee-single-region.mmd`
- `diagrams/mermaid/apigee-multi-region-ha.mmd`
- `diagrams/mermaid/apigee-cicd-policy.mmd`
