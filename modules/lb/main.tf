locals {
  use_internal_lb = "${var.type == "INTERNAL" ? 1 : 0}"
  global_lb       = "${var.type == "INTERNAL" ? 0 : (var.global_lb ? 1 : 0)}"
  port_range      = "${element(var.ports, 1)}"

  #  health_check_type = "${var.health_check_path == "" ? "${google_compute_health_check.tcp.0.self_link}" : "${google_compute_health_check.http.0.self_link}"}"
}

############
# COMMON
############

resource "google_compute_firewall" "health_check" {
  name    = "${var.name}-health-check"
  network = "${var.network}"

  allow {
    protocol = "${var.protocol}"
    ports    = "${var.ports}"
  }

  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]

  target_tags = "${var.target_tags}"
}

resource "google_compute_instance_group" "lb" {
  // Count based on number of AZs
  count       = "${local.use_internal_lb ? 3 : 0}"
  name        = "${var.name}-${element(var.zones, count.index)}"
  description = "Terraform generated instance group that is multi-zone for Internal Load Balancing"
  zone        = "${element(var.zones, count.index)}"
  network     = "${var.network}"
}

resource "google_compute_address" "lb" {
  name         = "${var.name}"
  address_type = "${local.use_internal_lb > 0 ? "INTERNAL" : "EXTERNAL"}"
}

############
# EXTERNAL
############

resource "google_compute_http_health_check" "lb" {
  name                = "${var.name}"
  port                = "8080"
  request_path        = "${var.health_check_path}"
  check_interval_sec  = 5
  timeout_sec         = 3
  healthy_threshold   = 6
  unhealthy_threshold = 3

  count = "${local.global_lb}"
}

resource "google_compute_target_pool" "pool" {
  name = "${var.name}"

  health_checks = [
    "${google_compute_http_health_check.lb.name}",
  ]

  count = "${local.global_lb}"
}

resource "google_compute_forwarding_rule" "external_forwarding_rule" {
  count = "${local.global_lb}"

  name        = "${var.name}"
  port_range  = "${local.port_range}"
  ip_protocol = "${var.protocol}"

  ip_address = "${google_compute_address.lb.address}"
  target     = "${google_compute_target_pool.pool.self_link}"
}

############
# INTERNAL
############

resource "google_compute_firewall" "lb" {
  name    = "${var.name}"
  network = "${var.network}"

  allow {
    protocol = "${var.protocol}"
    ports    = "${var.ports}"
  }

  source_ranges = "${var.source_ranges}"
  target_tags   = "${var.target_tags}"

  count = "${local.use_internal_lb}"
}

resource "google_compute_health_check" "tcp" {
  name                = "${var.name}"
  check_interval_sec  = 5
  timeout_sec         = 3
  healthy_threshold   = 6
  unhealthy_threshold = 3

  tcp_health_check {
    port = "${var.health_check_port}"
  }

  count = "${local.use_internal_lb && var.health_check_path == "" ? 1 : 0}"
}

resource "google_compute_health_check" "http" {
  name                = "${var.name}"
  check_interval_sec  = 5
  timeout_sec         = 3
  healthy_threshold   = 6
  unhealthy_threshold = 3

  http_health_check {
    request_path = "${var.health_check_path}"
    port         = "${var.health_check_port}"
  }

  count = "${local.use_internal_lb && var.health_check_path == "" ? 0 : 1}"
}

resource "google_compute_region_backend_service" "backend_service" {
  name        = "${var.name}"
  protocol    = "${var.protocol}"
  timeout_sec = 900

  backend {
    group = "${google_compute_instance_group.lb.0.self_link}"
  }

  backend {
    group = "${google_compute_instance_group.lb.1.self_link}"
  }

  backend {
    group = "${google_compute_instance_group.lb.2.self_link}"
  }

  health_checks = ["${coalescelist(google_compute_health_check.tcp.*.self_link, google_compute_health_check.http.*.self_link)}"]

  count = "${local.use_internal_lb ? 1 : 0}"
}

resource "google_compute_forwarding_rule" "internal_forwarding_rule" {
  count = "${local.use_internal_lb ? 1 : 0}"

  name                  = "${var.name}"
  network               = "${var.network}"
  subnetwork            = "${var.subnetwork_name}"
  load_balancing_scheme = "INTERNAL"
  ip_protocol           = "${var.protocol}"
  ports                 = "${var.ports}"

  backend_service = "${google_compute_region_backend_service.backend_service.self_link}"

  count = "${local.use_internal_lb ? 1 : 0}"
}
