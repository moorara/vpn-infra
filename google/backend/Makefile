terraform.tfvars:
	@ read -p "Enter a Google Cloud location (see https://cloud.google.com/storage/docs/locations): " location; \
	  read -p "Enter a domain name registered with Google Cloud: " domain; \
	  echo "location = \"$$location\"" > terraform.tfvars; \
	  echo "domain   = \"$$domain\"" >> terraform.tfvars; \

.PHONY: init
init:
	@ terraform init

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
