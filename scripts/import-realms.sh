#!/bin/bash
set -e

KEYCLOAK_URL="${KEYCLOAK_URL:-https://auth.cumulus-creations.com}"
ADMIN_USER="${KEYCLOAK_ADMIN:-etty}"
ADMIN_PASSWORD="${KEYCLOAK_ADMIN_PASSWORD}"

if [ -z "$ADMIN_PASSWORD" ]; then
  echo "Error: KEYCLOAK_ADMIN_PASSWORD not set"
  exit 1
fi

echo "Getting admin token..."
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

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

for realm_file in "$SCRIPT_DIR"/../realms/*.json; do
  [ -f "$realm_file" ] || continue
  realm_name=$(jq -r '.realm' "$realm_file")

  echo "Importing realm: $realm_name"

  REALM_EXISTS=$(curl -s -o /dev/null -w "%{http_code}" \
    -H "Authorization: Bearer $TOKEN" \
    "$KEYCLOAK_URL/admin/realms/$realm_name")

  if [ "$REALM_EXISTS" == "200" ]; then
    echo "Realm exists, using partial import (OVERWRITE mode)..."

    RESPONSE=$(curl -s -w "\n%{http_code}" -X POST \
      "$KEYCLOAK_URL/admin/realms/$realm_name/partialImport" \
      -H "Authorization: Bearer $TOKEN" \
      -H "Content-Type: application/json" \
      -d @"$realm_file")

    HTTP_CODE=$(echo "$RESPONSE" | tail -1)
    BODY=$(echo "$RESPONSE" | head -n -1)

    if [ "$HTTP_CODE" == "200" ]; then
      ADDED=$(echo "$BODY" | jq -r '.added // 0')
      UPDATED=$(echo "$BODY" | jq -r '.overwritten // 0')
      SKIPPED=$(echo "$BODY" | jq -r '.skipped // 0')
      echo "Updated: $realm_name (added: $ADDED, updated: $UPDATED, skipped: $SKIPPED)"
    else
      echo "Warning: Partial import returned $HTTP_CODE"
      echo "$BODY" | jq -r '.errorMessage // .' 2>/dev/null || echo "$BODY"
    fi
  else
    echo "Creating new realm..."
    curl -s -X POST "$KEYCLOAK_URL/admin/realms" \
      -H "Authorization: Bearer $TOKEN" \
      -H "Content-Type: application/json" \
      -d @"$realm_file"
    echo "Created: $realm_name"
  fi
done

echo "Done"
