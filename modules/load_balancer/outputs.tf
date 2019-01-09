output "name" {
  value = "${element(concat(google_compute_target_pool.lb.*.name, list("")), 0)}"
}

output "backend_service_name" {
  value = "${element(concat(google_compute_backend_service.http_lb_backend_service.*.name, list("")), 0)}"
}

output "address" {
  value = "${element(concat(google_compute_address.lb.*.address, list("")), 0)}"
}

output "health_check_self_link" {
  value = "${element(concat(google_compute_http_health_check.lb.*.self_link, list("")), 0)}"
}

output "global_address" {
  value = "${element(concat(google_compute_global_address.lb.*.address, list("")), 0)}"
}
