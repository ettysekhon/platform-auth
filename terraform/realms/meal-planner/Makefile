.PHONY: init plan apply destroy fmt validate output client-secret update-k8s-secret

init:
	terraform init

fmt:
	terraform fmt -recursive

validate:
	terraform validate

plan:
	terraform plan

apply:
	terraform apply

destroy:
	terraform destroy

output:
	terraform output

client-secret:
	@terraform output -raw client_secret

update-k8s-secret:
	kubectl create secret generic meal-planner-mcp-client \
		--namespace meal-planner \
		--from-literal=client-id=$$(terraform output -raw client_id) \
		--from-literal=client-secret=$$(terraform output -raw client_secret) \
		--from-literal=issuer=$$(terraform output -raw issuer_url) \
		--dry-run=client -o yaml | kubectl apply -f -
