# Realm Management

## Overview

Realm configurations are stored as JSON files in `realms/` and imported via scripts.

| Without JSON | With JSON |
| ------------ | --------- |
| Manual UI clicks | Automated imports |
| No version history | Git tracks changes |
| Hard to replicate | Dev/prod parity |
| No code review | Review before deploy |
| Manual disaster recovery | `git checkout` to restore |

## Workflow

### Making Changes

```bash
# 1. Make changes in Keycloak UI
# 2. Export
./scripts/export-realms.sh meal-planner

# 3. Review
git diff realms/meal-planner.json

# 4. Commit
git add realms/meal-planner.json
git commit -m "feat(realm): add mcp:admin scope"
```

### Deploying

```bash
export KEYCLOAK_ADMIN_PASSWORD=xxx
./scripts/import-realms.sh
```

### Adding a Client

```bash
export KEYCLOAK_ADMIN_PASSWORD=xxx
./scripts/create-client.sh meal-planner new-app "https://app.example.com/*"
```

## Export Options

### Via CLI (recommended)

```bash
./scripts/export-realms.sh meal-planner
```

### Via Keycloak UI

1. Select realm → Realm settings
2. Action dropdown → Partial export
3. Export groups/roles: ON, Export clients: ON, Export users: OFF
4. Save to `realms/<realm-name>.json`

## Realm Structure

```json
{
  "realm": "meal-planner",
  "enabled": true,
  "roles": { "realm": [{ "name": "user" }, { "name": "admin" }] },
  "clientScopes": [{ "name": "mcp:read", "protocol": "openid-connect" }],
  "clients": [{
    "clientId": "meal-planner-mcp",
    "redirectUris": ["http://localhost:3000/*"],
    "attributes": { "pkce.code.challenge.method": "S256" }
  }]
}
```

## Security

Before committing, remove:

- Client secrets
- User passwords
- Tokens/session data

Client secrets should be stored in Kubernetes secrets and configured post-import.
