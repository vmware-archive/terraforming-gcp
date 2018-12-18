output "iaas" {
  value = "gcp"
}

output "project" {
  value = "${var.project}"
}

output "opsman_service_account_key" {
  sensitive = true
  value     = "${module.ops_manager.service_account_key}"
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

output "infrastructure_subnet_cidr" {
  value = "${module.infra.ip_cidr_range}"
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

# Control Plane

output "control_plane_domain" {
  value = "${module.control_plane.domain}"
}

output "control_plane_lb_name" {
  value = "${module.control_plane.load_balancer_name}"
}

output "control_plane_subnet_name" {
  value = "${module.control_plane.subnet_name}"
}

output "control_plane_subnet_gateway" {
  value = "${module.control_plane.subnet_gateway}"
}

output "control_plane_subnet_cidr" {
  value = "${module.control_plane.subnet_cidrs}"
}

#DEPRECATED
output "control_plane_subnet_cidrs" {
  value = ["${module.control_plane.subnet_cidrs}"]
}

output "infrastructure_subnet_cidrs" {
  value = "${module.infra.subnet_cidrs}"
}
