terraform.tfvars:
	@ read -p "Google Cloud service account file: " credentials_file; \
	  read -p "Google Cloud project: " project; \
	  echo "credentials_file = \"$$credentials_file\"" > terraform.tfvars; \
	  echo "project          = \"$$project\"" >> terraform.tfvars; \

config.gcs.tfbackend:
	@ read -p "Google Cloud service account file: " credentials; \
	  read -p "Enter the GCS bucket name for the Terraform backend: " bucket; \
	  echo "credentials = \"$$credentials\"" > config.gcs.tfbackend; \
	  echo "bucket      = \"$$bucket\"" >> config.gcs.tfbackend; \
