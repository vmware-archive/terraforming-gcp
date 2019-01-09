locals {
  count = "${var.global ? 1 : 0}"
}

resource "google_compute_backend_service" "http_lb_backend_service" {
  name        = "${var.env_name}-httpslb"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 900
  enable_cdn  = false

  backend {
    group = "${google_compute_instance_group.httplb.0.self_link}"
  }

  backend {
    group = "${google_compute_instance_group.httplb.1.self_link}"
  }

  backend {
    group = "${google_compute_instance_group.httplb.2.self_link}"
  }

  health_checks = ["${google_compute_http_health_check.lb.*.self_link}"]

  count = "${local.count}"
}

resource "google_compute_instance_group" "httplb" {
  // Count based on number of AZs
  count       = "${var.global > 0 ? 3 : 0}"
  name        = "${var.env_name}-httpslb-${element(var.zones, count.index)}"
  description = "terraform generated instance group that is multi-zone for https loadbalancing"
  zone        = "${element(var.zones, count.index)}"
}

resource "google_compute_global_address" "lb" {
  name = "${var.env_name}-${var.name}-address"

  count = "${local.count}"
}

resource "google_compute_url_map" "https_lb_url_map" {
  name = "${var.env_name}-cf-http"

  default_service = "${google_compute_backend_service.http_lb_backend_service.self_link}"

  count = "${local.count}"
}

resource "google_compute_target_http_proxy" "http_lb_proxy" {
  name        = "${var.env_name}-httpproxy"
  description = "really a load balancer but listed as an https proxy"
  url_map     = "${google_compute_url_map.https_lb_url_map.self_link}"

  count = "${local.count}"
}

resource "google_compute_target_https_proxy" "https_lb_proxy" {
  name             = "${var.env_name}-httpsproxy"
  description      = "really a load balancer but listed as an https proxy"
  url_map          = "${google_compute_url_map.https_lb_url_map.self_link}"
  ssl_certificates = ["${var.ssl_certificate}"]

  count = "${local.count}"
}

resource "google_compute_global_forwarding_rule" "cf_http" {
  name       = "${var.env_name}-cf-lb-http"
  ip_address = "${google_compute_global_address.lb.address}"
  target     = "${google_compute_target_http_proxy.http_lb_proxy.self_link}"
  port_range = "80"

  count = "${local.count}"
}

resource "google_compute_global_forwarding_rule" "cf_https" {
  name       = "${var.env_name}-cf-lb-https"
  ip_address = "${google_compute_global_address.lb.address}"
  target     = "${google_compute_target_https_proxy.https_lb_proxy.self_link}"
  port_range = "443"

  count = "${local.count}"
}
