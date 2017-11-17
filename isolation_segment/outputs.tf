output "load_balancer_name" {
  value = "${element(concat(google_compute_backend_service.isoseg_lb_backend_service.*.name, list("")), 0)}"
}
