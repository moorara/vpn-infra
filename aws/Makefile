terraform.tfvars:
	@ read -p "AWS Access Key: " access_key; \
	  read -p "AWS Secret Key: " secret_key; \
	  echo "access_key = \"$$access_key\"" > terraform.tfvars; \
	  echo "secret_key = \"$$secret_key\"" >> terraform.tfvars; \

config.s3.tfbackend:
	@ read -p "Enter the S3 bucket region for the Terraform backend: " region; \
	  read -p "Enter the S3 bucket name for the Terraform backend: " bucket; \
	  echo "region = \"$$region\"" > config.s3.tfbackend; \
	  echo "bucket = \"$$bucket\"" >> config.s3.tfbackend; \
