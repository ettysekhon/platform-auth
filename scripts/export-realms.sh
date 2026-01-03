#!/bin/bash
set -e

REALM="${1:-meal-planner}"
NAMESPACE="${NAMESPACE:-auth-platform}"
OUTPUT_DIR="$(cd "$(dirname "$0")/../realms" && pwd)"

POD=$(kubectl get pod -n "$NAMESPACE" -l app.kubernetes.io/component=keycloak -o jsonpath='{.items[0].metadata.name}')

if [ -z "$POD" ]; then
  echo "Error: Keycloak pod not found in namespace $NAMESPACE"
  exit 1
fi

echo "Exporting realm: $REALM"

kubectl exec -n "$NAMESPACE" "$POD" -- \
  /opt/keycloak/bin/kc.sh export \
  --realm "$REALM" \
  --file "/tmp/$REALM.json" \
  --users skip

kubectl cp "$NAMESPACE/$POD:/tmp/$REALM.json" "$OUTPUT_DIR/$REALM.json"

echo "Exported to: $OUTPUT_DIR/$REALM.json"
echo ""
echo "Review and remove sensitive data before committing"
