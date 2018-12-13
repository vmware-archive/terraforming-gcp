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

output "lb_name" {
  value = "${var.global_lb > 0 ? element(concat(google_compute_backend_service.http_lb_backend_service.*.name, list("")), 0) : element(concat(google_compute_target_pool.cf.*.name, list("")), 0)}"
}

output "cf_ws_address" {
  value = "${element(concat(google_compute_address.cf_ws.*.address, list("")), 0)}"
}

output "cf_tcp_address" {
  value = "${google_compute_address.cf-tcp.address}"
}

output "cf_ssh_address" {
  value = "${google_compute_address.cf-ssh.address}"
}

output "cf_public_health_check" {
  value = "${google_compute_http_health_check.cf_public.self_link}"
}
