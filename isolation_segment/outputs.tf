output "load_balancer_name" {
  value = "${google_compute_backend_service.isoseg_lb_backend_service.name}"
}
