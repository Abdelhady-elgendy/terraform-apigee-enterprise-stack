# CI/CD Templates

This repo includes copy-paste templates for enterprise pipelines.

## GitHub Actions

Template:
- `ci-templates/github-actions.yml`
Deploy workflow (manual):
- `.github/workflows/deploy.yml`

Stages:
- fmt
- validate
- tflint (optional)
- checkov (optional)
- policy gate (OPA/Conftest)
- plan artifact
- manual approval
- apply

## GitLab CI

Template:
- `ci-templates/gitlab-ci.yml`

Stages:
- validate
- policy
- plan
- approval
- apply

## Notes

- Customize backend configuration for your environment.
- Store plan output as an artifact for audit.
- Gate apply behind approvals in prod.
