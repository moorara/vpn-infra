terraform.tfvars:
	@ read -p "Enter a domain name registered with Google Cloud: " domain; \
	  read -p "Enter a space-separated list of names to create a subdomain for each: " names; \
	  echo "domain = \"$$domain\"" > terraform.tfvars; \
	  echo "names  = $$(echo "\"$$names\"" | jq -c 'split(" ")')" >> terraform.tfvars; \

.PHONY: init
init:
	@ terraform init \
	    -backend-config="../config.gcs.tfbackend"

.PHONY: format
format:
	@ terraform fmt

.PHONY: validate
validate:
	@ terraform validate

.PHONY: plan
plan:
	@ terraform plan \
	    -var-file="../terraform.tfvars"

.PHONY: apply
apply:
	@ terraform apply \
	    -var-file="../terraform.tfvars"

.PHONY: refresh
refresh:
	@ terraform refresh \
	    -var-file="../terraform.tfvars"

.PHONY: destroy
destroy:
	@ terraform destroy \
	    -var-file="../terraform.tfvars"

.PHONY: clean
clean:
	@ rm -rf .terraform .terraform.lock.hcl terraform.tfstate terraform.tfstate.backup
