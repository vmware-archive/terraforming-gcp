locals {
  uaa_lb_name              = "${var.env_name}-uaa-lb"
  credhub_lb_name          = "${var.env_name}-credhub-lb"
  uaa_healthcheck_port     = "8443"
  credhub_healthcheck_port = "8845"
  google_healthcheck_ips   = ["130.211.0.0/22", "35.191.0.0/16"]
  dns_name                 = "${replace(var.dns_zone_dns_name, "/\\.$/", "")}"
}

resource "google_compute_backend_service" "uaa_backend_service" {
  name        = "${var.env_name}-uaa-lb"
  port_name   = "uaa"
  protocol    = "HTTPS"
  timeout_sec = 900
  enable_cdn  = false

  backend {
    group = "${google_compute_instance_group.uaa_lb.0.self_link}"
  }

  backend {
    group = "${google_compute_instance_group.uaa_lb.1.self_link}"
  }

  backend {
    group = "${google_compute_instance_group.uaa_lb.2.self_link}"
  }

  health_checks = ["${google_compute_health_check.uaa_lb.self_link}"]
}

resource "google_compute_backend_service" "credhub_backend_service" {
  name        = "${var.env_name}-credhub-lb"
  port_name   = "credhub"
  protocol    = "HTTPS"
  timeout_sec = 900
  enable_cdn  = false

  backend {
    group = "${google_compute_instance_group.credhub_lb.0.self_link}"
  }

  backend {
    group = "${google_compute_instance_group.credhub_lb.1.self_link}"
  }

  backend {
    group = "${google_compute_instance_group.credhub_lb.2.self_link}"
  }

  health_checks = ["${google_compute_https_health_check.credhub_lb.self_link}"]
}

resource "google_compute_instance_group" "uaa_lb" {
  name  = "${var.env_name}-uaa-lb-${element(var.zones, count.index)}"
  zone  = "${element(var.zones, count.index)}"
  count = "${length(var.zones)}"

  named_port = {
    name = "uaa"
    port = "8443"
  }
}

resource "google_compute_instance_group" "credhub_lb" {
  name  = "${var.env_name}-credhub-lb-${element(var.zones, count.index)}"
  zone  = "${element(var.zones, count.index)}"
  count = "${length(var.zones)}"

  named_port = {
    name = "credhub"
    port = "8844"
  }
}

resource "google_compute_global_address" "https_lb_credhub" {
  name = "${var.env_name}-${count.index}-https-lb-credhub"
}

resource "google_compute_global_address" "https_lb_uaa" {
  name = "${var.env_name}-${count.index}-https-lb-uaa"
}

resource "google_compute_url_map" "https_lb_url_map" {
  name = "${var.env_name}-https"

  # This is arbitrary. Our rules should always match
  default_service = "${google_compute_backend_service.uaa_backend_service.self_link}"

  host_rule = {
    hosts        = ["uaa.${local.dns_name}"]
    path_matcher = "uaa"
  }

  host_rule = {
    hosts        = ["credhub.${local.dns_name}"]
    path_matcher = "credhub"
  }

  path_matcher = {
    name            = "uaa"
    default_service = "${google_compute_backend_service.uaa_backend_service.self_link}"
  }

  path_matcher = {
    name            = "credhub"
    default_service = "${google_compute_backend_service.credhub_backend_service.self_link}"
  }
}

resource "google_compute_target_https_proxy" "credhub_https_lb_proxy" {
  name             = "${var.env_name}-credhub-httpsproxy"
  description      = "really a load balancer but listed as an https proxy"
  url_map          = "${google_compute_url_map.https_lb_url_map.self_link}"
  ssl_certificates = ["${google_compute_ssl_certificate.lb_managed_cert.self_link}"]
}

resource "google_compute_target_https_proxy" "uaa_https_lb_proxy" {
  name             = "${var.env_name}-uaa-httpsproxy"
  description      = "really a load balancer but listed as an https proxy"
  url_map          = "${google_compute_url_map.https_lb_url_map.self_link}"
  ssl_certificates = ["${google_compute_ssl_certificate.lb_managed_cert.self_link}"]
}

resource "google_compute_global_forwarding_rule" "uaa_https" {
  name       = "${var.env_name}-uaa-lb-https"
  ip_address = "${google_compute_global_address.https_lb_uaa.address}"
  target     = "${google_compute_target_https_proxy.uaa_https_lb_proxy.self_link}"
  port_range = "443"
}

resource "google_compute_global_forwarding_rule" "credhub_https" {
  name       = "${var.env_name}-credhub-lb-https"
  ip_address = "${google_compute_global_address.https_lb_credhub.address}"
  target     = "${google_compute_target_https_proxy.credhub_https_lb_proxy.self_link}"
  port_range = "443"
}

resource "google_compute_https_health_check" "credhub_lb" {
  name         = "${var.env_name}-credhub-health-check"
  port         = "${local.credhub_healthcheck_port}"
  request_path = "/health"
}

resource "google_compute_health_check" "uaa_lb" {
  name = "${var.env_name}-uaa-health-check"

  https_health_check = {
    request_path = "/healthz"
    port         = "${local.uaa_healthcheck_port}"
  }
}

resource "google_compute_firewall" "uaa_lb" {
  name    = "${var.env_name}-uaa-firewall"
  network = "${var.network}"

  allow {
    protocol = "tcp"
    ports    = ["8443"]
  }

  target_tags = ["${local.uaa_lb_name}"]
}

resource "google_compute_firewall" "credhub_lb" {
  name    = "${var.env_name}-credhub-firewall"
  network = "${var.network}"

  allow {
    protocol = "tcp"
    ports    = ["8844"]
  }

  target_tags = ["${local.credhub_lb_name}"]
}

resource "google_compute_firewall" "health_check" {
  name    = "${var.env_name}-https-health-check"
  network = "${var.network}"

  allow {
    protocol = "tcp"

    ports = [
      "${local.uaa_healthcheck_port}",
      "${local.credhub_healthcheck_port}",
    ]
  }

  source_ranges = "${local.google_healthcheck_ips}"

  target_tags = [
    "${local.uaa_lb_name}",
    "${local.credhub_lb_name}",
  ]
}

resource "google_compute_firewall" "atc_to_uaa" {
  name      = "${var.env_name}-atc-firewall"
  network   = "${var.network}"
  direction = "EGRESS"

  destination_ranges = [
    "${google_compute_global_address.https_lb_uaa.address}/32",
  ]

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  target_tags = ["${module.plane-lb.name}"]
}
