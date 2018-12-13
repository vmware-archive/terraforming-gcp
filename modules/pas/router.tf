///**********
// * PAS LB *
// **********/

resource "google_compute_firewall" "cf_public" {
  name    = "${var.env_name}-cf-public"
  network = "${var.network}"

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  target_tags = [
    "${var.env_name}-${var.global_lb > 0 ? "httpslb" : "tcplb"}",
    "${var.env_name}-cf-ws",
    "${var.env_name}-isoseglb",
  ]
}

resource "google_compute_global_address" "cf" {
  name = "${var.env_name}-cf"

  count = "${var.global_lb}"
}

resource "google_compute_address" "cf" {
  name = "${var.env_name}-cf"

  count = "${var.global_lb > 0 ? 0 : 1}"
}

resource "google_compute_instance_group" "httplb" {
  // Count based on number of AZs
  count       = "${var.global_lb > 0 ? 3 : 0}"
  name        = "${var.env_name}-httpslb-${element(var.zones, count.index)}"
  description = "terraform generated instance group that is multi-zone for https loadbalancing"
  zone        = "${element(var.zones, count.index)}"
}

resource "google_compute_http_health_check" "cf_public" {
  name                = "${var.env_name}-cf-public"
  port                = 8080
  request_path        = "/health"
  check_interval_sec  = 5
  timeout_sec         = 3
  healthy_threshold   = 6
  unhealthy_threshold = 3
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

  health_checks = ["${google_compute_http_health_check.cf_public.self_link}"]

  count = "${var.global_lb}"
}

resource "google_compute_url_map" "https_lb_url_map" {
  name = "${var.env_name}-cf-http"

  default_service = "${google_compute_backend_service.http_lb_backend_service.self_link}"

  count = "${var.global_lb}"
}

resource "google_compute_target_http_proxy" "http_lb_proxy" {
  name        = "${var.env_name}-httpproxy"
  description = "really a load balancer but listed as an https proxy"
  url_map     = "${google_compute_url_map.https_lb_url_map.self_link}"

  count = "${var.global_lb}"
}

resource "google_compute_target_https_proxy" "https_lb_proxy" {
  name             = "${var.env_name}-httpsproxy"
  description      = "really a load balancer but listed as an https proxy"
  url_map          = "${google_compute_url_map.https_lb_url_map.self_link}"
  ssl_certificates = ["${var.ssl_certificate}"]

  count = "${var.global_lb}"
}

resource "google_compute_firewall" "cf-health_check" {
  name    = "${var.env_name}-cf-health-check"
  network = "${var.network}"

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]

  target_tags = [
    "${var.env_name}-${var.global_lb > 0 ? "httpslb" : "tcplb"}",
    "${var.env_name}-cf-ws",
    "${var.env_name}-isoseglb",
  ]
}

resource "google_compute_target_pool" "cf" {
  name = "${var.env_name}-tcplb"

  health_checks = [
    "${google_compute_http_health_check.cf_public.name}",
  ]

  count = "${var.global_lb > 0 ? 0 : 1}"
}

resource "google_compute_global_forwarding_rule" "cf_http" {
  name       = "${var.env_name}-cf-lb-http"
  ip_address = "${google_compute_global_address.cf.address}"
  target     = "${google_compute_target_http_proxy.http_lb_proxy.self_link}"
  port_range = "80"

  count = "${var.global_lb}"
}

resource "google_compute_forwarding_rule" "cf_http" {
  name        = "${var.env_name}-cf-lb-http"
  ip_address  = "${google_compute_address.cf.address}"
  target      = "${google_compute_target_pool.cf.self_link}"
  port_range  = "80"
  ip_protocol = "TCP"

  count = "${var.global_lb > 0 ? 0 : 1}"
}

resource "google_compute_global_forwarding_rule" "cf_https" {
  name       = "${var.env_name}-cf-lb-https"
  ip_address = "${google_compute_global_address.cf.address}"
  target     = "${google_compute_target_https_proxy.https_lb_proxy.self_link}"
  port_range = "443"

  count = "${var.global_lb}"
}

resource "google_compute_forwarding_rule" "cf_https" {
  name        = "${var.env_name}-cf-lb-https"
  ip_address  = "${google_compute_address.cf.address}"
  target      = "${google_compute_target_pool.cf.self_link}"
  port_range  = "443"
  ip_protocol = "TCP"

  count = "${var.global_lb > 0 ? 0 : 1}"
}

///**********
// * TCP LB *
// **********/

resource "google_compute_address" "cf_ws" {
  name = "${var.env_name}-cf-ws"

  count = "${var.global_lb}"
}

resource "google_compute_target_pool" "cf_ws" {
  name = "${var.env_name}-cf-ws"

  health_checks = [
    "${google_compute_http_health_check.cf_public.name}",
  ]

  count = "${var.global_lb}"
}

resource "google_compute_forwarding_rule" "cf-ws-https" {
  name        = "${var.env_name}-cf-ws-https"
  target      = "${google_compute_target_pool.cf_ws.self_link}"
  port_range  = "443"
  ip_protocol = "TCP"
  ip_address  = "${google_compute_address.cf_ws.address}"

  count = "${var.global_lb}"
}

resource "google_compute_forwarding_rule" "cf-ws-http" {
  name        = "${var.env_name}-cf-ws-http"
  target      = "${google_compute_target_pool.cf_ws.self_link}"
  port_range  = "80"
  ip_protocol = "TCP"
  ip_address  = "${google_compute_address.cf_ws.address}"

  count = "${var.global_lb}"
}

///****************
// * Diego SSH LB *
// ****************/

resource "google_compute_firewall" "cf-ssh" {
  name    = "${var.env_name}-cf-ssh"
  network = "${var.network}"

  allow {
    protocol = "tcp"
    ports    = ["2222"]
  }

  target_tags = ["${var.env_name}-cf-ssh"]
}

resource "google_compute_address" "cf-ssh" {
  name = "${var.env_name}-cf-ssh"
}

resource "google_compute_target_pool" "cf-ssh" {
  name = "${var.env_name}-cf-ssh"
}

resource "google_compute_forwarding_rule" "cf-ssh" {
  name        = "${var.env_name}-cf-ssh"
  target      = "${google_compute_target_pool.cf-ssh.self_link}"
  port_range  = "2222"
  ip_protocol = "TCP"
  ip_address  = "${google_compute_address.cf-ssh.address}"
}
