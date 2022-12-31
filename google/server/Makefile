name := $(shell cat terraform.tfvars | grep name | grep -oe '".*"')

ssh_user := admin
ssh_path := ssh
key_file := $(ssh_path)/vpn-$(name)

terraform.tfvars:
	@ read -p "Enter a Google Cloud region: " region; \
	  read -p "Enter a name for the deployment: " name; \
	  read -p "Enter a subdomain for accessing the VPN server: " subdomain; \
	  read -p "Enter an email address for registering an account with ACME: " acme_email; \
	  echo "region     = \"$$region\"" > terraform.tfvars; \
	  echo "name       = \"$$name\"" >> terraform.tfvars; \
	  echo "subdomain  = \"$$subdomain\"" >> terraform.tfvars; \
	  echo "acme_email = \"$$acme_email\"" >> terraform.tfvars; \

config.gcs.tfbackend:
	@ read -p "Enter the name of deployment: " name; \
	  echo "prefix = \"server/$$name/terraform\"" > config.gcs.tfbackend; \

.PHONY: keys
keys:
	@ mkdir -p $(ssh_path)
	@ ssh-keygen -f $(key_file) -t rsa -N '' -C $(ssh_user) 1> /dev/null && \
	  chmod 400 $(key_file) && \
	  mv $(key_file) $(key_file).pem

.PHONY: init
init:
	@ terraform init \
	    -backend-config="../config.gcs.tfbackend" \
	    -backend-config="config.gcs.tfbackend"

.PHONY: format
format:
	@ terraform fmt

.PHONY: validate
validate:
	@ terraform validate

.PHONY: plan
plan:
	@ terraform plan \
	    -var-file="../terraform.tfvars" \
	    -var ssh_public_key_file=$(key_file).pub \
	    -var ssh_private_key_file=$(key_file).pem

.PHONY: apply
apply:
	@ terraform apply \
	    -var-file="../terraform.tfvars" \
	    -var ssh_public_key_file=$(key_file).pub \
	    -var ssh_private_key_file=$(key_file).pem

.PHONY: refresh
refresh:
	@ terraform refresh \
	    -var-file="../terraform.tfvars" \
	    -var ssh_public_key_file=$(key_file).pub \
	    -var ssh_private_key_file=$(key_file).pem

.PHONY: destroy
destroy:
	@ terraform destroy \
	    -var-file="../terraform.tfvars" \
	    -var ssh_public_key_file=$(key_file).pub \
	    -var ssh_private_key_file=$(key_file).pem

.PHONY: clean
clean:
	@ rm -rf $(ssh_path) && \
	  rm -rf .terraform .terraform.lock.hcl terraform.tfstate terraform.tfstate.backup
