output "load_balancer_name" {
  value = "${element(concat(google_compute_target_pool.pks-api.*.name, list("")), 0)}"
}

output "domain" {
  value = "${replace(replace(element(concat(google_dns_record_set.wildcard-pks-dns.*.name, list("")), 0), "/^\\*\\./", ""), "/\\.$/", "")}"
}

output "pks_subnet_name" {
  value = "${element(concat(google_compute_subnetwork.pks-subnet.*.name, list("")), 0)}"
}

output "pks_subnet_gateway" {
  value = "${element(concat(google_compute_subnetwork.pks-subnet.*.gateway_address, list("")), 0)}"
}

output "pks_subnet_cidrs" {
  value = "${element(concat(google_compute_subnetwork.pks-subnet.*.ip_cidr_range, list("")), 0)}"
}

output "pks_services_subnet_name" {
  value = "${element(concat(google_compute_subnetwork.pks-services-subnet.*.name, list("")), 0)}"
}

output "pks_services_subnet_gateway" {
  value = "${element(concat(google_compute_subnetwork.pks-services-subnet.*.gateway_address, list("")), 0)}"
}

output "pks_services_subnet_cidrs" {
  value = "${element(concat(google_compute_subnetwork.pks-services-subnet.*.ip_cidr_range, list("")), 0)}"
}
