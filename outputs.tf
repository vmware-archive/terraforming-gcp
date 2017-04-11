output "service_account_email" {
  value = "${google_service_account.opsman_service_account.email}"
}

output "ops_manager_dns" {
  value = "${google_dns_record_set.ops-manager-dns.name}"
}

output "optional_ops_manager_dns" {
  value = "${google_dns_record_set.optional-ops-manager-dns.name}"
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

output "optional_ops_manager_public_ip" {
  value = "${google_compute_instance.optional-ops-manager.network_interface.0.access_config.0.assigned_nat_ip}"
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

output "azs" {
  value = "${var.zones}"
}

output "vm_tag" {
  value = "${var.env_name}-vms"
}

output "network_name" {
  value = "${google_compute_network.pcf-network.name}"
}

output "sql_db_ip" {
  value = "${module.external_database.ip}"
}

output "management_subnet_gateway" {
  value = "${google_compute_subnetwork.management-subnet.gateway_address}"
}

output "management_subnet_cidrs" {
  value = ["${google_compute_subnetwork.management-subnet.ip_cidr_range}"]
}

output "management_subnet_name" {
  value = "${google_compute_subnetwork.management-subnet.name}"
}

output "opsman_sql_db_name" {
  value = "${module.external_database.opsman_sql_db_name}"
}

output "ert_subnet_gateway" {
  value = "${google_compute_subnetwork.ert-subnet.gateway_address}"
}

output "ert_subnet_cidrs" {
  value = ["${google_compute_subnetwork.ert-subnet.ip_cidr_range}"]
}

output "ert_subnet_name" {
  value = "${google_compute_subnetwork.ert-subnet.name}"
}

output "services_subnet_gateway" {
  value = "${google_compute_subnetwork.services-subnet.gateway_address}"
}

output "services_subnet_cidrs" {
  value = ["${google_compute_subnetwork.services-subnet.ip_cidr_range}"]
}

output "services_subnet_name" {
  value = "${google_compute_subnetwork.services-subnet.name}"
}

output "http_lb_backend_name" {
  value = "${google_compute_backend_service.http_lb_backend_service.name}"
}

output "isoseg_lb_backend_name" {
  value = "${google_compute_backend_service.isoseg_lb_backend_service.name}"
}

output "ws_router_pool" {
  value = "${google_compute_target_pool.cf-ws.name}"
}

output "ssh_router_pool" {
  value = "${google_compute_target_pool.cf-ssh.name}"
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

output "ert_sql_username" {
  value = "${module.external_database.ert_sql_username}"
}

output "ert_sql_password" {
  value = "${module.external_database.ert_sql_password}"
}

output "opsman_sql_username" {
  value = "${module.external_database.opsman_sql_username}"
}

output "opsman_sql_password" {
  value = "${module.external_database.opsman_sql_password}"
}

output "ops_manager_ssh_private_key" {
  value = "${tls_private_key.ops-manager.private_key_pem}"
}

output "ops_manager_ssh_public_key" {
  value = "${format("ubuntu:%s", tls_private_key.ops-manager.public_key_openssh)}"
}
