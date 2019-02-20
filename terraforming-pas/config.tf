variable "generate_config_files" {
  default = false
}

variable "mysql_monitor_email" {
  type = "string"
}

locals {
  generate_config_files = "${var.generate_config_files ? 1 : 0}"
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

    pas_subnet_name    = "${module.pas.pas_subnet_name}"
    pas_subnet_cidr    = "${module.pas.pas_subnet_ip_cidr_range}"
    pas_subnet_gateway = "${module.pas.pas_subnet_gateway}"

    services_subnet_name    = "${module.pas.services_subnet_name}"
    services_subnet_cidr    = "${module.pas.services_subnet_ip_cidr_range}"
    services_subnet_gateway = "${module.pas.services_subnet_gateway}"

    opsman_service_account_key = "${module.ops_manager.service_account_key}"

    vm_tag = "${var.env_name}-vms"
  }
}

resource "local_file" "director_config_yml" {
  count = "${local.generate_config_files}"

  filename = "director-config.yml"
  content  = "${data.template_file.director_config.rendered}"
}

output "director_config_yml" {
  value = "${data.template_file.director_config.rendered}"
}

resource "random_string" "credhub_encryption_password" {
  length  = 16
  special = false
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

    pas_subnet_name      = "${module.pas.pas_subnet_name}"
    services_subnet_name = "${module.pas.services_subnet_name}"

    ssh_lb_name = "${module.pas.ssh_lb_name}"
    web_lb_name = "${module.pas.lb_name}"

    sys_domain  = "${module.pas.sys_domain}"
    apps_domain = "${module.pas.apps_domain}"
    tcp_domain  = "${module.pas.tcp_domain}"

    mysql_monitor_email         = "${var.mysql_monitor_email}"
    credhub_encryption_password = "${random_string.credhub_encryption_password.result}"

    ssl_cert        = "${module.pas_certs.ssl_cert}"
    ssl_private_key = "${module.pas_certs.ssl_private_key}"

    ws_router_pool  = "${module.pas.ws_router_pool}"
    tcp_router_pool = "${module.pas.tcp_router_pool}"
  }
}

resource "local_file" "product_config_yml" {
  count = "${local.generate_config_files}"

  filename = "product-config.yml"
  content  = "${data.template_file.product_config_yml.rendered}"
}

output "product_config_yml" {
  value = "${data.template_file.product_config_yml.rendered}"
}

locals {
  director_config_yml = <<DIRECTORCONFIGYML
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
  - name: $${pas_subnet_name}
    subnets:
    - availability_zone_names: $${az_names}
      cidr: $${pas_subnet_cidr}
      dns: 169.254.169.254
      gateway: $${pas_subnet_gateway}
      iaas_identifier: $${network_name}/$${pas_subnet_name}/$${region}
      reserved_ip_ranges: $${cidrhost(pas_subnet_cidr, 0)}-$${cidrhost(pas_subnet_cidr, 4)}
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

DIRECTORCONFIGYML

  product_config_yml = <<PRODUCTCONFIGYML
---
product-name: cf
network-properties:
  network:
    name: $${pas_subnet_name}
  service_network:
    name: $${services_subnet_name}
  other_availability_zones: $${az_config}
  singleton_availability_zone:
    name: $${az_singleton}
product-properties:
  .cloud_controller.apps_domain:
    value: $${apps_domain}
  .cloud_controller.system_domain:
    value: $${sys_domain}
  .ha_proxy.skip_cert_verify:
    value: true
  .mysql_monitor.recipient_email:
    value: $${mysql_monitor_email}
  .properties.credhub_key_encryption_passwords:
    value:
    - key:
        secret: $${credhub_encryption_password}
      name: Key
      primary: true
      provider: internal
  .properties.haproxy_forward_tls:
    value: disable
  .properties.networking_poe_ssl_certs:
    value:
    - certificate:
        cert_pem: |
          $${indent(10, trimspace(ssl_cert))}
        private_key_pem: |
          $${indent(10, trimspace(ssl_private_key))}
      name: Certificate
  .properties.security_acknowledgement:
    value: X
  .properties.system_blobstore:
    value: internal
  .properties.tcp_routing:
    value: enable
  .properties.tcp_routing.enable.reservable_ports:
    value: 1024-1123
  .uaa.service_provider_key_credentials:
    value:
        cert_pem: |
          $${indent(10, trimspace(ssl_cert))}
        private_key_pem: |
          $${indent(10, trimspace(ssl_private_key))}
resource-config:
  compute:
    instances: 1
  control:
    elb_names:
    - tcp:$${ssh_lb_name}
  router:
    elb_names:
    - http:$${web_lb_name}
    - tcp:$${ws_router_pool}
    instances: 1
  tcp_router:
    elb_names:
    - tcp:$${tcp_router_pool}

PRODUCTCONFIGYML
}
