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

# External Database

output "sql_db_ip" {
  value = "${module.external_database.ip}"
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

# PKS

output "pks_api_endpoint" {
  value = "${module.pks.api_endpoint}"
}

output "pks_lb_backend_name" {
  value = "${module.pks.load_balancer_name}"
}

output "pks_subnet_name" {
  value = "${module.pks.pks_subnet_name}"
}

output "pks_subnet_gateway" {
  value = "${module.pks.pks_subnet_gateway}"
}

output "pks_subnet_cidrs" {
  value = ["${module.pks.pks_subnet_cidrs}"]
}

output "services_subnet_name" {
  value = "${module.pks.pks_services_subnet_name}"
}

output "services_subnet_gateway" {
  value = "${module.pks.pks_services_subnet_gateway}"
}

output "services_subnet_cidrs" {
  value = ["${module.pks.pks_services_subnet_cidrs}"]
}

output "pks_master_node_service_account_key" {
  value     = "${module.pks.pks_master_node_service_account_key}"
  sensitive = true
}

output "pks_worker_node_service_account_key" {
  value     = "${module.pks.pks_worker_node_service_account_key}"
  sensitive = true
}

# Certificates

output "ssl_cert" {
  sensitive = true
  value     = "${var.ssl_cert}"
}

output "ssl_private_key" {
  sensitive = true
  value     = "${var.ssl_private_key}"
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

output "pks_services_subnet_name" {
  value = "${module.pks.pks_services_subnet_name}"
}

output "pks_services_subnet_gateway" {
  value = "${module.pks.pks_services_subnet_gateway}"
}

output "pks_services_subnet_cidrs" {
  value = ["${module.pks.pks_services_subnet_cidrs}"]
}
