resource "google_compute_backend_service" "isoseg_lb_backend_service" {
  name        = "${var.env_name}-isoseglb"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 900
  enable_cdn  = false

  // Sharing healthcheck with CF because it has the same configuration
  health_checks = ["${var.public_health_check_link}"]

  count = "${var.count}"

  backend {
    group = "${google_compute_instance_group.isoseglb.0.self_link}"
  }

  backend {
    group = "${google_compute_instance_group.isoseglb.1.self_link}"
  }

  backend {
    group = "${google_compute_instance_group.isoseglb.2.self_link}"
  }
}
