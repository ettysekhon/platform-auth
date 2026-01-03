.PHONY: setup lint template dry-run deploy pre-commit tf-init tf-plan tf-apply tf-output clean

NAMESPACE := auth-platform
RELEASE := platform-auth
VALUES := -f helm/values.yaml -f helm/values-dev.yaml
TF_DIR := terraform/realms/meal-planner

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

tf-init:
	cd $(TF_DIR) && terraform init

tf-plan:
	cd $(TF_DIR) && terraform plan

tf-apply:
	cd $(TF_DIR) && terraform apply

tf-output:
	cd $(TF_DIR) && terraform output

tf-secret:
	@cd $(TF_DIR) && terraform output -raw client_secret

clean:
	helm uninstall $(RELEASE) -n $(NAMESPACE) || true
	kubectl delete pvc -n $(NAMESPACE) -l app.kubernetes.io/instance=$(RELEASE) || true
