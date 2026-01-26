# Cost and Sizing

This is a high-level guide to major cost drivers for Apigee X.

## Primary cost drivers

- Apigee runtime instances (per-region)
- Traffic volume and API call throughput
- Analytics storage and retention
- Networking costs (load balancers, PSC, egress)
- Logging and monitoring retention

## Sizing guidance (baseline)

- Start with a single instance per region for non-prod.
- Use multi-region for HA in production.
- Right-size logging and metrics retention windows.

## Cost controls

- Separate projects for prod vs non-prod.
- Use budgets and alerts at the project or folder level.
- Export logs to cheaper storage when retention is high.

## Notes

Actual pricing depends on your subscription and region. Use the GCP pricing calculator for current estimates and validate with your Google account team.
