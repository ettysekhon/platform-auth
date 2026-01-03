# Platform Auth

Keycloak 26.4.7 on GKE. Central OIDC provider for `cumulus-creations.com` subdomains.

## Deploy

```bash
make deploy                              # Helm install
export TF_VAR_keycloak_admin_password=x
make tf-init && make tf-apply            # Realm config
```

Tag to trigger CI deploy: `git tag v0.1.0 && git push origin v0.1.0`

## Structure

```text
helm/                     # Keycloak + PostgreSQL
terraform/realms/         # Realm configs per app
.github/workflows/        # ci.yaml (lint/test), deploy.yaml (GKE)
```

## Secrets

| Secret             | Source                                                      |
| ------------------ | ----------------------------------------------------------- |
| `GCP_WIF_PROVIDER` | `terraform output -raw wif_provider` (infrastructure repo)  |
| `GCP_WIF_SA`       | `terraform output -raw service_account_email`               |

## Endpoints

| Purpose        | URL                                                                                         |
| -------------- | ------------------------------------------------------------------------------------------- |
| Admin          | <https://auth.cumulus-creations.com/admin>                                                  |
| OIDC Discovery | <https://auth.cumulus-creations.com/realms/meal-planner/.well-known/openid-configuration>   |

## Operations

```bash
# Admin password
kubectl get secret keycloak-admin-secret -n auth-platform -o jsonpath='{.data.password}' | base64 -d

# Client secret
cd terraform/realms/meal-planner && terraform output -raw client_secret

# Port forward
kubectl port-forward svc/platform-auth-keycloak 8080:8080 -n auth-platform
```
