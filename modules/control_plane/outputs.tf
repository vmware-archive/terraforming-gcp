output "load_balancer_name" {
  value = "${google_compute_target_pool.control-plane.name}"
}

output "subnet_name" {
  value = "${google_compute_subnetwork.control-plane.name}"
}

output "subnet_gateway" {
  value = "${google_compute_subnetwork.control-plane.gateway_address}"
}

output "subnet_cidrs" {
  value = "${element(concat(google_compute_subnetwork.control-plane.*.ip_cidr_range, list("")), 0)}"
}

output "domain" {
  value = "${replace(google_dns_record_set.control-plane.name, "/\\.$/", "")}"
}
