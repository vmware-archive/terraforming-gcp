locals {
  firewall = "${length(var.ports) > 0}"
}

resource "google_compute_http_health_check" "lb" {
  name                = "${var.env_name}-${var.name}-health-check"
  port                = "${var.health_check_port}"
  request_path        = "/health"
  check_interval_sec  = "${var.health_check_interval}"
  timeout_sec         = "${var.health_check_timeout}"
  healthy_threshold   = "${var.health_check_healthy_threshold}"
  unhealthy_threshold = "${var.health_check_unhealthy_threshold}"

  count = "${var.health_check ? 1 : 0}"
}

resource "google_compute_firewall" "health_check" {
  name    = "${var.env_name}-${var.name}-health-check"
  network = "${var.network}"

  allow {
    protocol = "tcp"
    ports    = ["${var.health_check_port}"]
  }

  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]

  target_tags = "${var.target_tags}"

  count = "${var.health_check ? 1 : 0}"
}

resource "google_compute_firewall" "lb" {
  name    = "${var.env_name}-${var.name}-firewall"
  network = "${var.network}"

  allow {
    protocol = "tcp"
    ports    = "${var.ports}"
  }

  target_tags = "${var.target_tags}"

  count = "${local.firewall ? 1 : 0}"
}
