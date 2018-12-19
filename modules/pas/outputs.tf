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

# We should probably rename this output, this one refers to the actual tcp-lb and not the router-lb
output "tcp_router_pool" {
  value = "${module.tcp-lb.target_pool}"
}

output "cf_ws_address" {
  value = "${module.tcp-router-lb.address}"
}

output "ws_router_pool" {
  value = "${module.tcp-router-lb.target_pool}"
}

output "tcp_lb_name" {
  value = "${module.tcp-lb.target_pool}"
}

output "http_lb_backend_name" {
  value = "${module.router-lb.backend_service}"
}

output "ssh_lb_name" {
  value = "${module.ssh-lb.target_pool}"
}

output "ssh_router_pool" {
  value = "${module.ssh-lb.target_pool}"
}

output "lb_name" {
  value = "${module.router-lb.backend_service}"
}

output "cf_public_health_check" {
  value = "${module.router-lb.health_check}"
}
