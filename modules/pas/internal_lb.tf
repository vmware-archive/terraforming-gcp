resource "google_compute_firewall" "router_internal" {
  name    = "${var.env_name}-cf-internal"
  network = "${var.network}"

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = [
    "${var.pas_cidr}",
    "${var.services_cidr}",
  ]

  target_tags = [
    "${var.env_name}-router-lb",
    "${var.env_name}-cf-ws",
    "${var.env_name}-isoseglb",
  ]
}

resource "google_compute_firewall" "router_lb_health_check" {
  name    = "${var.env_name}-router-lb-health-check"
  network = "${var.network}"

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]

  target_tags = [
    "${var.env_name}-router-lb",
    "${var.env_name}-cf-ws",
    "${var.env_name}-isoseglb",
  ]
}

resource "google_compute_instance_group" "internal-lb" {
  // Count based on number of AZs
  count       = "${var.use_internal_load_balancers ? 3 : 0}"
  name        = "${var.env_name}-internal-lb-${element(var.zones, count.index)}"
  description = "Terraform generated instance group that is multi-zone for Internal Load Balancing"
  zone        = "${element(var.zones, count.index)}"
  network     = "${var.network}"
}

resource "google_compute_health_check" "router_internal" {
  name                = "${var.env_name}-router-internal"
  check_interval_sec  = 5
  timeout_sec         = 3
  healthy_threshold   = 6
  unhealthy_threshold = 3

  http_health_check {
    request_path = "/health"
    port         = "8080"
  }

  count = "${var.use_internal_load_balancers ? 1 : 0}"
}

resource "google_compute_region_backend_service" "router_internal" {
  name        = "${var.env_name}-router-lb"
  protocol    = "TCP"
  timeout_sec = 900

  backend {
    group = "${google_compute_instance_group.internal-lb.0.self_link}"
  }

  backend {
    group = "${google_compute_instance_group.internal-lb.1.self_link}"
  }

  backend {
    group = "${google_compute_instance_group.internal-lb.2.self_link}"
  }

  health_checks = ["${google_compute_health_check.router_internal.self_link}"]

  count = "${var.use_internal_load_balancers ? 1 : 0}"
}

resource "google_compute_forwarding_rule" "router_internal" {
  name                  = "${var.env_name}-router-internal-lb"
  backend_service       = "${google_compute_region_backend_service.router_internal.self_link}"
  network               = "${var.network}"
  subnetwork            = "${google_compute_subnetwork.pas.name}"
  load_balancing_scheme = "INTERNAL"
  ip_protocol           = "TCP"
  ports                 = ["80", "443"]
}
