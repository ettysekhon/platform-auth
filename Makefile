.PHONY: setup lint template dry-run deploy pre-commit import-realms export-realm get-secret clean

NAMESPACE := auth-platform
RELEASE := platform-auth
VALUES := -f helm/values.yaml -f helm/values-dev.yaml
REALM ?= meal-planner
CLIENT_ID ?= meal-planner-mcp

setup:
	uv tool install pre-commit
	pre-commit install

lint:
	helm lint ./helm

template:
	helm template $(RELEASE) ./helm $(VALUES)

dry-run:
	helm upgrade --install $(RELEASE) ./helm -n $(NAMESPACE) $(VALUES) --dry-run --debug

deploy:
	helm upgrade --install $(RELEASE) ./helm -n $(NAMESPACE) $(VALUES) --wait --atomic

pre-commit:
	pre-commit run --all-files

import-realms:
	./scripts/import-realms.sh

export-realm:
	./scripts/export-realms.sh $(REALM)

get-secret:
	./scripts/get-client-secret.sh $(REALM) $(CLIENT_ID)

clean:
	helm uninstall $(RELEASE) -n $(NAMESPACE) || true
	kubectl delete pvc -n $(NAMESPACE) -l app.kubernetes.io/instance=$(RELEASE) || true
