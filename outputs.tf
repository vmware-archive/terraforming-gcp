output "service_account_email" {
  value = "${google_service_account.opsman_service_account.email}"
}

output "ops_manager_dns" {
  value = "${replace(google_dns_record_set.ops-manager-dns.name, "/\\.$/", "")}"
}

output "optional_ops_manager_dns" {
  value = "${replace(element(concat(google_dns_record_set.optional-ops-manager-dns.*.name, list("")), 0), "/\\.$/", "")}"
}

output "sys_domain" {
  value = "${replace(replace(google_dns_record_set.wildcard-sys-dns.name, "/^\\*\\./", ""), "/\\.$/", "")}"
}

output "apps_domain" {
  value = "${replace(replace(google_dns_record_set.wildcard-apps-dns.name, "/^\\*\\./", ""), "/\\.$/", "")}"
}

output "tcp_domain" {
  value = "${replace(google_dns_record_set.tcp-dns.name, "/\\.$/", "")}"
}

output "ops_manager_public_ip" {
  value = "${google_compute_address.ops-manager-ip.address}"
}

output "optional_ops_manager_public_ip" {
  value = "${element(concat(google_compute_address.optional-ops-manager-ip.*.address, list("")), 0)}"
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

output "pas_subnet_gateway" {
  value = "${google_compute_subnetwork.pas-subnet.gateway_address}"
}

output "pas_subnet_cidrs" {
  value = ["${google_compute_subnetwork.pas-subnet.ip_cidr_range}"]
}

output "pas_subnet_name" {
  value = "${google_compute_subnetwork.pas-subnet.name}"
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

output "ssl_cert" {
  sensitive = true
  value     = "${length(var.ssl_ca_cert) > 0 ? element(concat(tls_locally_signed_cert.ssl_cert.*.cert_pem, list("")), 0) : var.ssl_cert}"
}

output "ssl_private_key" {
  sensitive = true
  value     = "${length(var.ssl_ca_cert) > 0 ? element(concat(tls_private_key.ssl_private_key.*.private_key_pem, list("")), 0) : var.ssl_private_key}"
}

output "isoseg_domain" {
  value = "${module.isolation_segment.domain}"
}

output "isoseg_lb_backend_name" {
  value = "${module.isolation_segment.load_balancer_name}"
}

output "iso_seg_ssl_cert" {
  sensitive = true
  value     = "${module.isolation_segment.ssl_cert}"
}

output "iso_seg_ssl_private_key" {
  sensitive = true
  value     = "${module.isolation_segment.ssl_private_key}"
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
  value = "${element(concat(google_storage_bucket.buildpacks.*.name, list("")), 0)}"
}

output "droplets_bucket" {
  value = "${element(concat(google_storage_bucket.droplets.*.name, list("")), 0)}"
}

output "packages_bucket" {
  value = "${element(concat(google_storage_bucket.packages.*.name, list("")), 0)}"
}

output "resources_bucket" {
  value = "${element(concat(google_storage_bucket.resources.*.name, list("")), 0)}"
}

output "director_blobstore_bucket" {
  value = "${element(concat(google_storage_bucket.director.*.name, list("")), 0)}"
}

output "pas_sql_username" {
  value = "${module.external_database.pas_sql_username}"
}

output "pas_sql_password" {
  sensitive = true
  value     = "${module.external_database.pas_sql_password}"
}

output "opsman_sql_username" {
  value = "${module.external_database.opsman_sql_username}"
}

output "opsman_sql_password" {
  sensitive = true
  value     = "${module.external_database.opsman_sql_password}"
}

output "ops_manager_ssh_private_key" {
  sensitive = true
  value     = "${tls_private_key.ops-manager.private_key_pem}"
}

output "ops_manager_ssh_public_key" {
  sensitive = true
  value     = "${format("ubuntu:%s", tls_private_key.ops-manager.public_key_openssh)}"
}

output "cf_ws_address" {
  value = "${google_compute_address.cf-ws.address}"
}

output "dns_managed_zone" {
  value = "${google_dns_managed_zone.env_dns_zone.name}"
}

output "pks_domain" {
  value = "${module.pks.domain}"
}

output "pks_lb_backend_name" {
  value = "${module.pks.load_balancer_name}"
}
