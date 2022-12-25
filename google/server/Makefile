ssh_user := admin
ssh_path := ssh
key_file := $(ssh_path)/vpn


terraform.tfvars:
	@ echo 'credentials_file = "tbd"' >> terraform.tfvars
	@ echo 'project          = "tbd"' >> terraform.tfvars
	@ echo 'region           = "tbd"' >> terraform.tfvars
	@ echo 'name             = "tbd"' >> terraform.tfvars
	@ echo 'subdomain        = "tbd"' >> terraform.tfvars
	@ echo 'acme_email       = "tbd"' >> terraform.tfvars

config.gcs.tfbackend:
	@ echo 'credentials = "tbd"' >> config.gcs.tfbackend
	@ echo 'bucket      = "tbd"' >> config.gcs.tfbackend
	@ echo 'prefix      = "tbd"' >> config.gcs.tfbackend

.PHONY: keys
keys:
	@ mkdir -p $(ssh_path)
	@ ssh-keygen -f $(key_file) -t rsa -N '' -C $(ssh_user) 1> /dev/null && \
	  chmod 400 $(key_file) && \
	  mv $(key_file) $(key_file).pem

.PHONY: init
init:
	@ terraform init \
	    -backend-config=config.gcs.tfbackend

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
