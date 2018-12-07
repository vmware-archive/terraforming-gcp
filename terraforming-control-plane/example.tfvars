env_name="" # Environment name. This will be prefixed to most resources created by Terraform.
project="" # GCP Project ID
region="" # GCP Region (e.g. us-west1)
zones=[] # GCP Zones (e.g. ["us-west1-a", "us-west1-b"])
opsman_image_url="" # Ops Manager URL (from the GCP YML on PivNet; e.g. https://storage.googleapis.com/ops-manager-us/pcf-gcp-2.3-build.188.tar.gz)
dns_suffix="" # DNS Suffix to be combined with "env_name" (entries will be created for opsman.<env_name>.<dns_suffix> and concourse.<env_name>.<dns_suffix>)

# GCP Service Account Key JSON
service_account_key=<<SERVICE_ACCOUNT_KEY
SERVICE_ACCOUNT_KEY
