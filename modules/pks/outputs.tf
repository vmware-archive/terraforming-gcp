output "load_balancer_name" {
  value = "${google_compute_target_pool.pks-api.name}"
}

output "pks_subnet_name" {
  value = "${google_compute_subnetwork.pks-subnet.name}"
}

output "pks_subnet_gateway" {
  value = "${google_compute_subnetwork.pks-subnet.gateway_address}"
}

output "pks_subnet_cidrs" {
  value = "${element(concat(google_compute_subnetwork.pks-subnet.*.ip_cidr_range, list("")), 0)}"
}

output "pks_services_subnet_name" {
  value = "${google_compute_subnetwork.pks-services-subnet.name}"
}

output "pks_services_subnet_gateway" {
  value = "${google_compute_subnetwork.pks-services-subnet.gateway_address}"
}

output "pks_services_subnet_cidrs" {
  value = "${google_compute_subnetwork.pks-services-subnet.ip_cidr_range}"
}

output "pks_master_node_service_account_key" {
  value = "${base64decode(google_service_account_key.pks_master_node_service_account_key.private_key)}"
}

output "pks_worker_node_service_account_key" {
  value = "${base64decode(google_service_account_key.pks_worker_node_service_account_key.private_key)}"
}

output "api_endpoint" {
  value = "api.${replace(replace(google_dns_record_set.wildcard-pks-dns.name, "/^\\*\\./", ""), "/\\.$/", "")}"
}
