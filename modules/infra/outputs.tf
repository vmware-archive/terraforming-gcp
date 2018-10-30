output "network" {
  value = "${google_compute_network.pcf.self_link}"
}

output "network_name" {
  value = "${google_compute_network.pcf.name}"
}

output "subnet" {
  value = "${google_compute_subnetwork.infrastructure.self_link}"
}

output "ip_cidr_range" {
  value = "${google_compute_subnetwork.infrastructure.ip_cidr_range}"
}

output "dns_zone_dns_name" {
  value = "${google_dns_managed_zone.default.dns_name}"
}

output "dns_zone_name" {
  value = "${google_dns_managed_zone.default.name}"
}

output "dns_zone_name_servers" {
  value = "${google_dns_managed_zone.default.name_servers}"
}

output "subnet_gateway" {
  value = "${google_compute_subnetwork.infrastructure.gateway_address}"
}

output "subnet_cidrs" {
  value = ["${google_compute_subnetwork.infrastructure.ip_cidr_range}"]
}

output "subnet_name" {
  value = "${google_compute_subnetwork.infrastructure.name}"
}

output "blobstore_gcp_service_account_key" {
  value     = "${base64decode(element(concat(google_service_account_key.blobstore_service_account_key.*.private_key, list("")), 0))}"
  sensitive = true
}

output "blobstore_service_account_email" {
  value = "${element(concat(google_service_account.blobstore_service_account.*.email, list("")), 0)}"
}

output "blobstore_service_account_project" {
  value = "${element(concat(google_service_account.blobstore_service_account.*.project, list("")), 0)}"
}
