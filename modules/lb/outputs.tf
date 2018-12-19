output "address" {
  value = "${google_compute_address.lb.address}"
}

output "target_pool" {
  value = "${element(concat(google_compute_target_pool.pool.*.name, list("")), 0)}"
}

output "backend_service" {
  value = "${element(concat(google_compute_region_backend_service.backend_service.*.name, list("")), 0)}"
}

output "health_check" {
  value = "${element(concat(google_compute_health_check.tcp.*.self_link, list("")), 0)}"
}
