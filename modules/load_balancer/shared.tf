locals {
  firewall_ports = "${split(":", local.discrete_lbs ? join(":", keys(var.ports_lb_map)) : join(":", var.ports))}"
  firewall       = "${length(local.firewall_ports) > 0}"
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

  target_tags = ["${compact(concat(local.lb_names, list(var.optional_target_tag)))}"]

  count = "${var.health_check ? 1 : 0}"
}

resource "google_compute_firewall" "lb" {
  name    = "${var.env_name}-${var.name}-firewall${local.discrete_lbs ? format("-%d", count.index) : ""}"
  network = "${var.network}"

  allow {
    protocol = "tcp"
    ports    = "${split(":", local.discrete_lbs ? element(local.firewall_ports, count.index) : join(":", local.firewall_ports))}"
  }

  target_tags = ["${compact(concat(split(":", local.discrete_lbs ? element(local.lb_names, count.index) : join(":", local.lb_names)), list(var.optional_target_tag)))}"]

  count = "${local.firewall ? local.discrete_lbs ? length(local.firewall_ports) : 1 : 0}"
}
