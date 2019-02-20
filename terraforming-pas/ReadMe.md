# Terraforming PAS for GCP

The following are experimental WIP instructions. Please follow official docs https://docs.pivotal.io/.

## Requirements

- `terraform version`
  **v0.11.x**

  The following should be installed using `terraform init`

  - provider.google v1.20.0
  - provider.local v1.1.0
  - provider.random v2.0.0
  - provider.template v2.0.0
  - provider.tls v1.2.0

- `om --version`
  **v0.53.0**

- Pivotal Cloud Foundry Operations Manager
  **v2.4.4**

- Small Footprint PAS
  **v2.4.3**

  (Download this from https://network.pivotal.io)

  Set `SOME_PATH_TO_PRODUCT_TILE`

  *Note make sure you are checking signature.*

- Stemcells for PCF
  **170.24-170.30** (tested with 170.30)

  (Download this from https://network.pivotal.io)

  Set `SOME_PATH_TO_STEMCELL`

  *Note make sure you are checking signature.*

## Environment Configuration

The following variables can be configured as environment variables or can be
written to a tfvars file.

Follow instructions in the root of the project to setup terraform variables.

Also set
- `mysql_monitor_email` to some admin email
- `generate_config_files` to `true`
- `env_name` to some environment name

Make sure your `opsman_image_url` is set to the correct version.

## Pave, Configure, and Deploy PAS

```sh
# Pave infrastructure =====================================

terraform init

terraform apply # this requires user input

# Configure DNS ===========================================

terraform output env_dns_zone_name_servers

#  use this output to create an NS record
#  to avoid Negative DNS Cacheing wait 2 minutes

# Configure Ops Manager and Tiles =========================

export OM_USERNAME=admin \
  OM_PASSWORD="$(terraform output om_password)" \
  OM_TARGET="https://$(terraform output ops_manager_dns)"

om -k configure-authentication -dp "${OM_PASSWORD}"

om -k configure-director --config director-config.yml

om -k upload-stemcell --stemcell $SOME_PATH_TO_STEMCELL

om -k upload-product --product $SOME_PATH_TO_PRODUCT_TILE

om -k stage-product --product-name cf --product-version 2.4.2

om -k configure-product --config director-product.yml

# Deploy ==================================================

om -k apply-changes

```
