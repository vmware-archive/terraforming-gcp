variable "generate_config_files" {
  default = false
}

locals {
  generate_yml = "${var.generate_config_files ? 1 : 0}"
}

data "template_file" "director_config" {
  template = "${local.director_config_yml}"

  vars {
    project = "${var.project}"
    region  = "${var.region}"

    az_config    = "[${join(", ", formatlist("{%q: %q}", "name", var.zones))}]"
    az_names     = "[${join(", ", var.zones)}]"
    az_singleton = "${element(var.zones, 0)}"

    network_name = "${module.infra.network_name}"

    infrastructure_subnet_name    = "${module.infra.subnet_name}"
    infrastructure_subnet_cidr    = "${module.infra.ip_cidr_range}"
    infrastructure_subnet_gateway = "${module.infra.subnet_gateway}"

    pks_subnet_name    = "${module.pks.pks_subnet_name}"
    pks_subnet_cidr    = "${module.pks.pks_subnet_cidrs}"
    pks_subnet_gateway = "${module.pks.pks_subnet_gateway}"

    services_subnet_name    = "${module.pks.pks_services_subnet_name}"
    services_subnet_cidr    = "${module.pks.pks_services_subnet_cidrs}"
    services_subnet_gateway = "${module.pks.pks_services_subnet_gateway}"

    opsman_service_account_key = "${module.ops_manager.service_account_key}"

    vm_tag = "${var.env_name}-vms"
  }
}

resource "local_file" "director_config_yml" {
  count = "${local.generate_yml}"

  filename = "director-config.yml"
  content  = "${data.template_file.director_config.rendered}"
}

output "director_config_yml" {
  value = "${data.template_file.director_config.rendered}"
}

resource "random_string" "om_password" {
  length  = 16
  special = false
}

output "om_password" {
  value = "${random_string.om_password.result}"
}

data "template_file" "product_config_yml" {
  template = "${local.product_config_yml}"

  vars {
    az_config    = "[${join(", ", formatlist("{%q: %q}", "name", var.zones))}]"
    az_singleton = "${element(var.zones, 0)}"

    pks_subnet_name          = "${module.pks.pks_subnet_name}"
    pks_services_subnet_name = "${module.pks.pks_services_subnet_name}"
  }
}

resource "local_file" "product_config_yml" {
  count = "${local.generate_yml}"

  filename = "product-config.yml"
  content  = "${data.template_file.product_config_yml.rendered}"
}

output "product_config_yml" {
  value = "${data.template_file.product_config_yml.rendered}"
}

locals {
  director_config_yml = <<DIRECTOR_CONFIG_YML
---
az-configuration: $${az_config}
properties-configuration:
  director_configuration:
    ntp_servers_string: 169.254.169.254
  iaas_configuration:
    auth_json: |
      $${indent(6, trimspace(opsman_service_account_key))}
    default_deployment_tag: $${vm_tag}
    project: $${project}
network-assignment:
  network:
    name: $${infrastructure_subnet_name}
  singleton_availability_zone:
    name: $${az_singleton}
networks-configuration:
  icmp_checks_enabled: false
  networks:
  - name: $${infrastructure_subnet_name}
    subnets:
    - availability_zone_names: $${az_names}
      cidr: $${infrastructure_subnet_cidr}
      dns: 169.254.169.254
      gateway: $${infrastructure_subnet_gateway}
      iaas_identifier: $${network_name}/$${infrastructure_subnet_name}/$${region}
      reserved_ip_ranges: $${cidrhost(infrastructure_subnet_cidr, 0)}-$${cidrhost(infrastructure_subnet_cidr, 4)}
  - name: $${pks_subnet_name}
    subnets:
    - availability_zone_names: $${az_names}
      cidr: $${pks_subnet_cidr}
      dns: 169.254.169.254
      gateway: $${pks_subnet_gateway}
      iaas_identifier: $${network_name}/$${pks_subnet_name}/$${region}
      reserved_ip_ranges: $${cidrhost(pks_subnet_cidr, 0)}-$${cidrhost(pks_subnet_cidr, 4)}
  - name: $${services_subnet_name}
    subnets:
    - availability_zone_names: $${az_names}
      cidr: $${services_subnet_cidr}
      dns: 169.254.169.254
      gateway: $${services_subnet_gateway}
      iaas_identifier: $${network_name}/$${services_subnet_name}/$${region}
      reserved_ip_ranges: $${cidrhost(services_subnet_cidr, 0)}-$${cidrhost(services_subnet_cidr, 4)}
resource-configuration:
  compilation:
    instance_type:
      id: xlarge.disk

DIRECTOR_CONFIG_YML

  product_config_yml = <<PRODUCT_CONFIG_YML
---
product-name: pivotal-container-service
network-properties:
  network:
    name: $${pks_subnet_name}
  service_network:
    name: $${pks_services_subnet_name}
  other_availability_zones: $${az_config}
  singleton_availability_zone:
    name: $${az_singleton}
product-properties:
resource-config:
  web:
    internet_connected: false
  db:
    internet_connected: false
PRODUCT_CONFIG_YML
}
