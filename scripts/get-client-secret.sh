#!/bin/bash
set -e

KEYCLOAK_URL="${KEYCLOAK_URL:-https://auth.cumulus-creations.com}"
ADMIN_USER="${KEYCLOAK_ADMIN:-etty}"
ADMIN_PASSWORD="${KEYCLOAK_ADMIN_PASSWORD}"
REALM="${1}"
CLIENT_ID="${2}"

if [ -z "$REALM" ] || [ -z "$CLIENT_ID" ]; then
  echo "Usage: $0 <realm> <client-id>"
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

CLIENT_UUID=$(curl -s "$KEYCLOAK_URL/admin/realms/$REALM/clients?clientId=$CLIENT_ID" \
  -H "Authorization: Bearer $TOKEN" \
  | jq -r '.[0].id')

if [ "$CLIENT_UUID" == "null" ] || [ -z "$CLIENT_UUID" ]; then
  echo "Client not found: $CLIENT_ID"
  exit 1
fi

SECRET=$(curl -s "$KEYCLOAK_URL/admin/realms/$REALM/clients/$CLIENT_UUID/client-secret" \
  -H "Authorization: Bearer $TOKEN" \
  | jq -r '.value')

echo "$SECRET"
