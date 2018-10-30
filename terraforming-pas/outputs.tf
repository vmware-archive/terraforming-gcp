output "iaas" {
  value = "gcp"
}

output "project" {
  value = "${var.project}"
}

output "service_account_key" {
  sensitive = true
  value     = "${var.service_account_key}"
}

output "region" {
  value = "${var.region}"
}

output "azs" {
  value = "${var.zones}"
}

output "vm_tag" {
  value = "${var.env_name}-vms"
}

output "dns_managed_zone" {
  value = "${module.infra.dns_zone_name}"
}

output "env_dns_zone_name_servers" {
  value = "${module.infra.dns_zone_name_servers}"
}

output "network_name" {
  value = "${module.infra.network_name}"
}

output "director_blobstore_bucket" {
  value = "${module.ops_manager.director_blobstore_bucket}"
}

output "infrastructure_subnet_gateway" {
  value = "${module.infra.subnet_gateway}"
}

output "infrastructure_subnet_cidrs" {
  value = "${module.infra.subnet_cidrs}"
}

output "infrastructure_subnet_name" {
  value = "${module.infra.subnet_name}"
}

output "infrastructure_subnets" {
  value = ["${module.infra.subnet_name}"]
}

# Ops Manager

output "service_account_email" {
  value = "${module.ops_manager.service_account_email}"
}

output "ops_manager_dns" {
  value = "${module.ops_manager.ops_manager_dns}"
}

output "ops_manager_public_ip" {
  value = "${module.ops_manager.ops_manager_public_ip}"
}

output "ops_manager_ip" {
  value = "${module.ops_manager.ops_manager_ip}"
}

output "ops_manager_ssh_private_key" {
  sensitive = true
  value     = "${module.ops_manager.ops_manager_ssh_private_key}"
}

output "ops_manager_ssh_public_key" {
  sensitive = true
  value     = "${module.ops_manager.ops_manager_ssh_public_key}"
}

# Optional Ops Manager

output "optional_ops_manager_dns" {
  value = "${module.ops_manager.optional_ops_manager_dns}"
}

output "optional_ops_manager_public_ip" {
  value = "${module.ops_manager.optional_ops_manager_public_ip}"
}

output "ops_manager_private_ip" {
  value = "${module.ops_manager.ops_manager_private_ip}"
}

# PAS

output "pas_blobstore_gcp_service_account_key" {
  value     = "${module.infra.blobstore_gcp_service_account_key}"
  sensitive = true
}

output "pas_blobstore_service_account_email" {
  value = "${module.infra.blobstore_service_account_email}"
}

output "pas_blobstore_service_account_project" {
  value = "${module.infra.blobstore_service_account_project}"
}

output "sys_domain" {
  value = "${module.pas.sys_domain}"
}

output "apps_domain" {
  value = "${module.pas.apps_domain}"
}

output "tcp_domain" {
  value = "${module.pas.tcp_domain}"
}

output "ws_router_pool" {
  value = "${module.pas.ws_router_pool}"
}

output "ssh_lb_name" {
  value = "${module.pas.ssh_lb_name}"
}

output "ssh_router_pool" {
  value = "${module.pas.ssh_router_pool}"
}

output "tcp_lb_name" {
  value = "${module.pas.tcp_lb_name}"
}

output "tcp_router_pool" {
  value = "${module.pas.tcp_router_pool}"
}

output "buildpacks_bucket" {
  value = "${module.pas.buildpacks_bucket}"
}

output "droplets_bucket" {
  value = "${module.pas.droplets_bucket}"
}

output "packages_bucket" {
  value = "${module.pas.packages_bucket}"
}

output "resources_bucket" {
  value = "${module.pas.resources_bucket}"
}

output "pas_subnet_gateway" {
  value = "${module.pas.pas_subnet_gateway}"
}

output "pas_subnet_cidrs" {
  value = ["${module.pas.pas_subnet_ip_cidr_range}"]
}

output "pas_subnet_name" {
  value = "${module.pas.pas_subnet_name}"
}

output "pas_subnets" {
  value = ["${module.pas.pas_subnet_name}"]
}

output "services_subnet_gateway" {
  value = "${module.pas.services_subnet_gateway}"
}

output "services_subnet_cidrs" {
  value = ["${module.pas.services_subnet_ip_cidr_range}"]
}

output "services_subnet_name" {
  value = "${module.pas.services_subnet_name}"
}

output "services_subnets" {
  value = ["${module.pas.services_subnet_name}"]
}

output "web_lb_name" {
  value = "${module.pas.lb_name}"
}

output "http_lb_backend_name" {
  value = "${module.pas.lb_name}"
}

output "cf_ws_address" {
  value = "${module.pas.cf_ws_address}"
}

output "haproxy_static_ip" {
  value = "${module.pas.haproxy_static_ip}"
}

# Certificates

output "ssl_cert" {
  sensitive = true
  value     = "${module.pas_certs.ssl_cert}"
}

output "ssl_private_key" {
  sensitive = true
  value     = "${module.pas_certs.ssl_private_key}"
}

# Isolation Segment

output "isoseg_domain" {
  value = "${module.isolation_segment.domain}"
}

output "isoseg_lb_backend_name" {
  value = "${module.isolation_segment.load_balancer_name}"
}

output "iso_seg_ssl_cert" {
  sensitive = true
  value     = "${module.isoseg_certs.ssl_cert}"
}

output "iso_seg_ssl_private_key" {
  sensitive = true
  value     = "${module.isoseg_certs.ssl_private_key}"
}

output "iso_seg_haproxy_static_ip" {
  value = "${module.isolation_segment.haproxy_static_ip}"
}

# External Database

output "sql_db_ip" {
  value = "${module.external_database.ip}"
}

output "pas_sql_username" {
  value = "${module.pas.sql_username}"
}

output "pas_sql_password" {
  sensitive = true
  value     = "${module.pas.sql_password}"
}

output "opsman_sql_username" {
  value = "${module.ops_manager.sql_username}"
}

output "opsman_sql_password" {
  sensitive = true
  value     = "${module.ops_manager.sql_password}"
}

output "opsman_sql_db_name" {
  value = "${module.ops_manager.sql_db_name}"
}

/*****************************
 * Deprecated *
 *****************************/

output "management_subnet_gateway" {
  value = "${module.infra.subnet_gateway}"
}

output "management_subnet_cidrs" {
  value = "${module.infra.subnet_cidrs}"
}

output "management_subnet_name" {
  value = "${module.infra.subnet_name}"
}

output "management_subnets" {
  value = ["${module.infra.subnet_name}"]
}
