output "ops_manager_dns" {
  value = "${google_dns_record_set.ops-manager-dns.name}"
}

output "sys_domain" {
  value = "sys.${var.env_name}.${var.dns_suffix}"
}

output "apps_domain" {
  value = "apps.${var.env_name}.${var.dns_suffix}"
}

output "tcp_domain" {
  value = "tcp.${var.env_name}.${var.dns_suffix}"
}

output "ops_manager_public_ip" {
  value = "${google_compute_instance.ops-manager.network_interface.0.access_config.0.assigned_nat_ip}"
}

output "env_dns_zone_name_servers" {
  value = "${google_dns_managed_zone.env_dns_zone.name_servers}"
}

output "project" {
  value = "${var.project}"
}

output "region" {
  value = "${var.region}"
}

output "az" {
  value = "${var.zone}"
}

output "service_account_key" {
  value = "${var.service_account_key}"
}

output "vm_tag" {
  value = "${var.env_name}-vms"
}

output "zones" {
  value = "[${var.zone}]"
}

output "network_name" {
  value = "${google_compute_network.pcf-network.name}"
}

output "ops_manager_gateway" {
  value = "${google_compute_subnetwork.ops-manager-subnet.gateway_address}"
}

output "ops_manager_cidr" {
  value = "${google_compute_subnetwork.ops-manager-subnet.ip_cidr_range}"
}

output "ops_manager_subnet" {
  value = "${google_compute_subnetwork.ops-manager-subnet.name}"
}

output "opsman_sql_db_ip" {
  value = "${google_sql_database_instance.master.ip_address.0.ip_address}"
}

output "opsman_sql_db_name" {
  value = "${google_sql_database.users.name}"
}

output "cf_gateway" {
  value = "${google_compute_subnetwork.cf-subnet.gateway_address}"
}

output "cf_cidr" {
  value = "${google_compute_subnetwork.cf-subnet.ip_cidr_range}"
}

output "cf_subnet" {
  value = "${google_compute_subnetwork.cf-subnet.name}"
}

output "router_pool" {
  value = "${google_compute_target_pool.cf-public.name}"
}

output "tcp_router_pool" {
  value = "${google_compute_target_pool.cf-tcp.name}"
}

output "buildpacks_bucket" {
  value = "${google_storage_bucket.buildpacks.name}"
}

output "droplets_bucket" {
  value = "${google_storage_bucket.droplets.name}"
}

output "packages_bucket" {
  value = "${google_storage_bucket.packages.name}"
}

output "resources_bucket" {
  value = "${google_storage_bucket.resources.name}"
}

output "director_blobstore_bucket" {
  value = "${google_storage_bucket.director.name}"
}
