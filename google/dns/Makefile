terraform.tfvars:
	@ echo 'credentials_file = "tbd"' >> terraform.tfvars
	@ echo 'project          = "tbd"' >> terraform.tfvars
	@ echo 'domain           = "tbd"' >> terraform.tfvars
	@ echo 'names            = "tbd"' >> terraform.tfvars

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
	@ terraform plan

.PHONY: apply
apply:
	@ terraform apply

.PHONY: refresh
refresh:
	@ terraform refresh

.PHONY: destroy
destroy:
	@ terraform destroy

.PHONY: clean
clean:
	@ rm -rf .terraform .terraform.lock.hcl terraform.tfstate terraform.tfstate.backup
