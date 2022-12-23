ssh_path := ssh
key_file := $(ssh_path)/vpn


terraform.tfvars:
	@ echo 'access_key = "tbd"' >> terraform.tfvars
	@ echo 'secret_key = "tbd"' >> terraform.tfvars
	@ echo 'region     = "tbd"' >> terraform.tfvars
	@ echo 'name       = "tbd"' >> terraform.tfvars
	@ echo 'domain     = "tbd"' >> terraform.tfvars
	@ echo 'email      = "tbd"' >> terraform.tfvars

.PHONY: keys
keys:
	@ mkdir -p $(ssh_path)
	@ ssh-keygen -f $(key_file) -t rsa -N '' 1> /dev/null && \
	  chmod 400 $(key_file) && \
	  mv $(key_file) $(key_file).pem

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
	    -var ssh_public_key_file=$(key_file).pub \
	    -var ssh_private_key_file=$(key_file).pem

.PHONY: apply
apply:
	@ terraform apply \
	    -var ssh_public_key_file=$(key_file).pub \
	    -var ssh_private_key_file=$(key_file).pem

.PHONY: refresh
refresh:
	@ terraform refresh \
	    -var ssh_public_key_file=$(key_file).pub \
	    -var ssh_private_key_file=$(key_file).pem

.PHONY: destroy
destroy:
	@ terraform destroy \
	    -var ssh_public_key_file=$(key_file).pub \
	    -var ssh_private_key_file=$(key_file).pem

.PHONY: clean
clean:
	@ rm -rf $(ssh_path) && \
	  rm -rf .terraform .terraform.lock.hcl terraform.tfstate terraform.tfstate.backup
