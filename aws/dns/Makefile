terraform.tfvars:
	@ echo 'access_key = "tbd"' >> terraform.tfvars
	@ echo 'secret_key = "tbd"' >> terraform.tfvars
	@ echo 'region     = "tbd"' >> terraform.tfvars
	@ echo 'domain     = "tbd"' >> terraform.tfvars
	@ echo 'names      = "tbd"' >> terraform.tfvars

config.s3.tfbackend:
	@ echo 'bucket = "tbd"' >> config.s3.tfbackend
	@ echo 'region = "tbd"' >> config.s3.tfbackend

.PHONY: init
init:
	@ terraform init \
	    -backend-config=config.s3.tfbackend

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
