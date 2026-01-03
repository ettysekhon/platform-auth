# Platform Auth

Keycloak 26.4.7 OAuth 2.1/OIDC authentication platform for `cumulus-creations.com`.

## Prerequisites

- GKE Standard cluster with `auth-platform` namespace
- cert-manager with `letsencrypt-prod` ClusterIssuer
- nginx ingress controller
- Helm 4.x

## Quick Start

```bash
# Local deploy
helm upgrade --install platform-auth ./helm \
  -n auth-platform \
  -f helm/values.yaml \
  -f helm/values-dev.yaml

# Or tag to deploy via CI
git tag v0.1.0 && git push origin v0.1.0
```

## CI/CD

### Workflows

| Workflow | Trigger | Purpose |
| -------- | ------- | ------- |
| `ci.yaml` | Push/PR to main | Lint, security scan, chart test, deploy on main |
| `deploy.yaml` | Tag `v*` or manual | Deploy to GKE |

### Required Secrets

Configure in GitHub → Settings → Secrets → Actions:

| Secret | Source | Description |
| ------ | ------ | ----------- |
| `GCP_WIF_PROVIDER` | `terraform output -raw wif_provider` | Workload Identity provider |
| `GCP_WIF_SA` | `terraform output -raw service_account_email` | Service account email |

Secrets are managed in the [infrastructure](https://github.com/ettysekhon/infrastructure) repo via Terraform.

## Structure

```text
helm/                 # Helm chart (Keycloak + PostgreSQL)
realms/               # Realm JSON configurations
scripts/              # Import/export scripts
docs/                 # Additional documentation
.github/workflows/    # CI and deploy workflows
```

## Endpoints

- **Console**: <https://auth.cumulus-creations.com>
- **OIDC**: <https://auth.cumulus-creations.com/realms/{realm}/.well-known/openid-configuration>
