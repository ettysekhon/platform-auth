#!/bin/bash
set -e

KEYCLOAK_URL="${KEYCLOAK_URL:-https://auth.cumulus-creations.com}"
ADMIN_USER="${KEYCLOAK_ADMIN:-etty}"
ADMIN_PASSWORD="${KEYCLOAK_ADMIN_PASSWORD}"
REALM="${1}"
CLIENT_ID="${2}"
REDIRECT_URI="${3:-http://localhost:3000/*}"

if [ -z "$REALM" ] || [ -z "$CLIENT_ID" ]; then
  echo "Usage: $0 <realm> <client-id> [redirect-uri]"
  exit 1
fi

if [ -z "$ADMIN_PASSWORD" ]; then
  echo "Error: KEYCLOAK_ADMIN_PASSWORD not set"
  exit 1
fi

TOKEN=$(curl -s -X POST "$KEYCLOAK_URL/realms/master/protocol/openid-connect/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "username=$ADMIN_USER" \
  -d "password=$ADMIN_PASSWORD" \
  -d "grant_type=password" \
  -d "client_id=admin-cli" \
  | jq -r '.access_token')

if [ "$TOKEN" == "null" ] || [ -z "$TOKEN" ]; then
  echo "Failed to get admin token"
  exit 1
fi

CLIENT_JSON=$(cat <<EOF
{
  "clientId": "$CLIENT_ID",
  "enabled": true,
  "publicClient": false,
  "standardFlowEnabled": true,
  "redirectUris": ["$REDIRECT_URI"],
  "webOrigins": ["+"],
  "attributes": {
    "pkce.code.challenge.method": "S256"
  }
}
EOF
)

echo "Creating client: $CLIENT_ID in realm: $REALM"

RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$KEYCLOAK_URL/admin/realms/$REALM/clients" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d "$CLIENT_JSON")

HTTP_CODE=$(echo "$RESPONSE" | tail -1)

if [ "$HTTP_CODE" == "201" ]; then
  echo "Created client: $CLIENT_ID"
  echo ""
  echo "Get client secret from Keycloak UI or run:"
  echo "  curl -H 'Authorization: Bearer \$TOKEN' $KEYCLOAK_URL/admin/realms/$REALM/clients/<client-uuid>/client-secret"
elif [ "$HTTP_CODE" == "409" ]; then
  echo "Client already exists: $CLIENT_ID"
else
  echo "Failed to create client (HTTP $HTTP_CODE)"
  echo "$RESPONSE" | head -n -1
  exit 1
fi
