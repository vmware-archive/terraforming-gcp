resource "google_compute_backend_service" "bosh-backend-service" {
  name        = "${var.env_name}-bosh-backend-service"
  description = "Backend service for bosh"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 10
  enable_cdn  = false

  backend {
    group = "${google_compute_instance_group.bosh-instance-group.self_link}"
  }

  health_checks = ["${google_compute_http_health_check.bosh-backend-service.self_link}"]

  count = "${var.opsman_backend_services_count}"

}

resource "google_compute_http_health_check" "bosh-backend-service" {
  name               = "${var.env_name}-bosh-backend-service"
  request_path       = "/"
  check_interval_sec = 1
  timeout_sec        = 1

  count = "${var.opsman_backend_services_count}"
}

resource "google_compute_instance_group" "bosh-instance-group" {
  name        = "${var.env_name}-bosh-backend-service"
  zone        = "us-central1-a"

  count = "${var.opsman_backend_services_count}"
}

resource "google_compute_global_forwarding_rule" "bosh-global-forwarding-rule" {
  name       = "${var.env_name}-bosh-backend-service"
  target     = "${google_compute_target_http_proxy.bosh-http-proxy.self_link}"
  port_range = "80"

  count = "${var.opsman_backend_services_count}"
}

resource "google_compute_target_http_proxy" "bosh-http-proxy" {
  name        = "${var.env_name}-bosh-backend-service"
  url_map     = "${google_compute_url_map.bosh-url-map.self_link}"

  count = "${var.opsman_backend_services_count}"
}

resource "google_compute_url_map" "bosh-url-map" {
  name            = "${var.env_name}-bosh-backend-service"
  default_service = "${google_compute_backend_service.bosh-backend-service.self_link}"

  count = "${var.opsman_backend_services_count}"
}
