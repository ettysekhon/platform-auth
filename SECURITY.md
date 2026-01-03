# Security Policy

## Reporting Vulnerabilities

Do not create public issues. Email <etty.sekhon@gmail.com>.

Response: 48h acknowledgment, 7d status update.

## Security Controls

### CI/CD

| Tool | Purpose |
| ---- | ------- |
| Gitleaks | Secret detection (blocks PR) |
| Trivy | Config vulnerability scan → GitHub Security tab |
| Pluto | Deprecated K8s API detection |

### Authentication

- **WIF**: Workload Identity Federation (OIDC tokens, no service account keys)
- **TLS**: cert-manager with Let's Encrypt

### Secrets

- Never committed — `existingSecret` pattern in Helm values
- Created via `kubectl create secret` or external secret operator
- Pre-commit hooks detect secrets and private keys before push

## Advisories

- [Keycloak](https://www.keycloak.org/security)
- [PostgreSQL](https://www.postgresql.org/support/security/)
