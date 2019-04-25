output "load_balancer_name" {
  value = "${module.plane-lb.name}"
}

output "uaa_load_balancer_name" {
  value = "${google_compute_backend_service.uaa_backend_service.name}"
}

output "credhub_load_balancer_name" {
  value = "${google_compute_backend_service.credhub_backend_service.name}"
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

output "uaa_cert_id" {
  value = "${google_compute_managed_ssl_certificate.uaa_managed_cert.certificate_id}"
}
