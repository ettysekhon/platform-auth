# Meal Planner Realm

Terraform-managed Keycloak realm for the Meal Planner MCP server.

## Usage

```bash
export TF_VAR_keycloak_admin_password='xxx'
terraform init
terraform plan
terraform apply
```

## Migration from Existing Realm

```bash
terraform import keycloak_realm.meal_planner meal-planner
terraform import keycloak_openid_client.mcp_server meal-planner/<CLIENT_UUID>
terraform plan
```

Get client UUID:

```bash
curl -s "$KEYCLOAK_URL/admin/realms/meal-planner/clients?clientId=meal-planner-mcp" \
  -H "Authorization: Bearer $TOKEN" | jq -r '.[0].id'
```

## Outputs

```bash
terraform output -raw client_secret
terraform output -raw issuer_url
terraform output k8s_secret_command
```

## Scopes

| Default                       | Optional                       |
| ----------------------------- | ------------------------------ |
| `openid`, `profile`, `email`  | `offline_access`               |
| `meal-planner:recipes:read`   | `meal-planner:recipes:write`   |
| `meal-planner:plans:read`     | `meal-planner:plans:write`     |
| `meal-planner:shopping:read`  | `meal-planner:shopping:write`  |
|                               | `meal-planner:nutrition:read`  |
|                               | `meal-planner:premium:access`  |
|                               | `meal-planner:admin:manage`    |

## Test User

Set `create_test_user = true` (default):

- **Username**: `testuser` / **Password**: `TF_VAR_test_user_password`
- **Role**: `user` / **Group**: `individual`

## Limitations

- Brute force protection not supported by provider; configure via UI
- State stored in GCS: `tf-state-simple-gcp-data-pipeline/keycloak/meal-planner`
