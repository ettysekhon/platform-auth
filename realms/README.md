# Keycloak Realms

Realm configurations for `cumulus-creations.com`.

## Realms

| Realm | App URL | Clients |
| ----- | ------- | ------- |
| `meal-planner` | `meal-planner.cumulus-creations.com` | `meal-planner-mcp` |

## Commands

```bash
# Export (uses kubectl exec, no password needed)
make export-realm REALM=meal-planner

# Import (uses Keycloak API)
export KEYCLOAK_ADMIN_PASSWORD=xxx
make import-realms
```

## Client Secrets

Not stored in JSON. After import:

```bash
# Get from Keycloak UI: Clients → meal-planner-mcp → Credentials

# Store in K8s
kubectl create secret generic meal-planner-mcp-client \
  --namespace meal-planner \
  --from-literal=client-id=meal-planner-mcp \
  --from-literal=client-secret=<from-keycloak>
```

## What to Commit

| Commit | Never Commit |
| ------ | ------------ |
| Realm structure | Client secrets |
| Roles, scopes | User passwords |
| Client configs | Tokens |
| Protocol mappers | |
