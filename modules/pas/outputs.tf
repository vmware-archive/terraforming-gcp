output "cf_public_health_check" {
  value = "${google_compute_http_health_check.cf_public.self_link}"
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

output "ws_router_pool" {
  value = "${element(concat(google_compute_target_pool.cf_ws.*.name, list("")), 0)}"
}

output "ssh_lb_name" {
  value = "${google_compute_target_pool.cf-ssh.name}"
}

output "ssh_router_pool" {
  value = "${google_compute_target_pool.cf-ssh.name}"
}

output "tcp_lb_name" {
  value = "${google_compute_target_pool.cf-tcp.name}"
}

output "tcp_router_pool" {
  value = "${google_compute_target_pool.cf-tcp.name}"
}

output "pas_subnet_gateway" {
  value = "${google_compute_subnetwork.pas.gateway_address}"
}

output "pas_subnet_ip_cidr_range" {
  value = "${google_compute_subnetwork.pas.ip_cidr_range}"
}

output "pas_subnet_name" {
  value = "${google_compute_subnetwork.pas.name}"
}

output "services_subnet_gateway" {
  value = "${google_compute_subnetwork.services.gateway_address}"
}

output "services_subnet_ip_cidr_range" {
  value = "${google_compute_subnetwork.services.ip_cidr_range}"
}

output "services_subnet_name" {
  value = "${google_compute_subnetwork.services.name}"
}

output "lb_name" {
  value = "${var.global_lb > 0 ? element(concat(google_compute_backend_service.http_lb_backend_service.*.name, list("")), 0) : element(concat(google_compute_target_pool.cf.*.name, list("")), 0)}"
}

output "cf_ws_address" {
  value = "${element(concat(google_compute_address.cf_ws.*.address, list("")), 0)}"
}

output "haproxy_static_ip" {
  value = "${local.haproxy_static_ip}"
}

output "sql_username" {
  value = "${element(concat(random_id.pas_db_username.*.b64, list("")), 0)}"
}

output "sql_password" {
  sensitive = true
  value     = "${element(concat(random_id.pas_db_password.*.b64, list("")), 0)}"
}
