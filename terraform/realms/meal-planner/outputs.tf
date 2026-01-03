output "realm_id" {
  value = keycloak_realm.meal_planner.id
}

output "realm_name" {
  value = keycloak_realm.meal_planner.realm
}

output "client_id" {
  value = keycloak_openid_client.mcp_server.client_id
}

output "client_secret" {
  value     = keycloak_openid_client.mcp_server.client_secret
  sensitive = true
}

output "issuer_url" {
  value = "https://auth.cumulus-creations.com/realms/${keycloak_realm.meal_planner.realm}"
}

output "authorization_endpoint" {
  value = "https://auth.cumulus-creations.com/realms/${keycloak_realm.meal_planner.realm}/protocol/openid-connect/auth"
}

output "token_endpoint" {
  value = "https://auth.cumulus-creations.com/realms/${keycloak_realm.meal_planner.realm}/protocol/openid-connect/token"
}

output "jwks_uri" {
  value = "https://auth.cumulus-creations.com/realms/${keycloak_realm.meal_planner.realm}/protocol/openid-connect/certs"
}

output "default_scopes" {
  value = [
    "openid",
    "profile",
    "email",
    "meal-planner:recipes:read",
    "meal-planner:plans:read",
  ]
}

output "optional_scopes" {
  value = [
    "offline_access",
    "meal-planner:recipes:write",
    "meal-planner:plans:write",
    "meal-planner:shopping:read",
    "meal-planner:shopping:write",
    "meal-planner:nutrition:read",
    "meal-planner:premium:access",
    "meal-planner:admin:manage",
  ]
}

output "test_user_username" {
  value = var.create_test_user ? keycloak_user.test_user[0].username : null
}

output "k8s_secret_command" {
  value = <<-EOT
    kubectl create secret generic meal-planner-mcp-client \
      --namespace meal-planner \
      --from-literal=client-id=${keycloak_openid_client.mcp_server.client_id} \
      --from-literal=client-secret=$(terraform output -raw client_secret) \
      --from-literal=issuer=https://auth.cumulus-creations.com/realms/${keycloak_realm.meal_planner.realm} \
      --dry-run=client -o yaml | kubectl apply -f -
  EOT
}
