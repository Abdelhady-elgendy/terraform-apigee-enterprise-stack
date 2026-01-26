package terraform.guardrails

deny[msg] {
  input.resource_changes[_].type == "google_compute_firewall"
  msg := "Firewall changes must be reviewed by SecurityHub (example rule)."
}
