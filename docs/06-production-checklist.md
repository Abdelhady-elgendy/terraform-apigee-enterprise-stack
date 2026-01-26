# Production checklist

- [ ] Dedicated projects / folders for platform vs app teams
- [ ] Shared VPC + centrally managed firewall rules
- [ ] Hostname and certificate lifecycle defined (ACME or enterprise PKI)
- [ ] Logging/monitoring enabled; alerts routed to on-call
- [ ] Policy gates: terraform validate + security policy checks
- [ ] Drift detection scheduled
