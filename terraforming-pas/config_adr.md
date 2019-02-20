# Configure Ops Manager Products with Terraform Ouput

* Status: proposed

* Technical Story: [#163633146](https://www.pivotaltracker.com/story/show/163633146)

## Context and Problem Statement

Can we Configure bosh director and configure product automatically from terraform output?

## Decision Drivers

- Allow teams to test their features on non-standard infrastructure such as
  `internetless` and `external_db`

- Make of non-standard variables easier in our own CI. Currently we only test
  with required variables.

- Allow us to talk about tile configuration in more concrete way.

## Considered Options

- **terraform-provider-texplate** (custom provider)
- **terraform-provider-template** (standard terraform)

## Decision Outcome

**terraform-provider-template**

This does not require us to create and maintain a terraform provider.

## Pros and Cons of Considered Options

- **terraform-provider-texplate** (custom provider)

  Given we already use texplate, I created a terraform provider wrapping that
  was very similar to texplate's feature set [crhntr/terraform-provider-texplate](https://github.com/crhntr/terraform-provider-texplate).

  This solution would allow us to use existing product configuration templates.

  However, releasing and maintaining our own provider would require users to
  install the provider manually and we would need to ship it somehow (another
  pivnet file).

  Also it is usually best to limit logic in templates so the power of texplate might be too
  tempting.

- **terraform-provider-template** (standard terraform)

  The built in terraform template provider was the other considered option.

  As of terraform 0.11 does not allow you to pass "complex" data types, such as arrays and
  maps, as template vars. This was thought to be a non-starter since we need to
  pass a hash to configure availability zones. However, a shim was found and
  this is not an issue and can be readdressed when 0.12 is released.

## Apendix - Example ReadMe

### Terraforming PAS for GCP

The following are experimental WIP instructions. Please follow official docs https://docs.pivotal.io/.

#### Requirements

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

#### Environment Configuration

The following variables can be configured as environment variables or can be
written to a tfvars file.

Follow instructions in the root of the project to setup terraform variables.

Also set
- `mysql_monitor_email` to some admin email
- `generate_config_files` to `true`
- `env_name` to some environment name

Make sure your `opsman_image_url` is set to the correct version.

#### Pave, Configure, and Deploy PAS

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
