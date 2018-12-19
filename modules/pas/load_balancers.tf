module "router-lb" {
  source = "../lb"

  name     = "${var.env_name}-router-lb"
  protocol = "TCP"
  type     = "${var.use_internal_lb ? "INTERNAL" : "EXTERNAL"}"
  ports    = [80, 443]

  source_ranges = [
    "${var.pas_cidr}",
    "${var.services_cidr}",
  ]

  target_tags = ["${var.env_name}-router-lb"]

  health_check_path = "/health"
  health_check_port = "8080"

  zones = "${var.zones}"

  network         = "${var.network}"
  subnetwork_name = "${google_compute_subnetwork.pas.name}"
}

module "tcp-router-lb" {
  source = "../lb"

  name     = "${var.env_name}-tcp-router-lb"
  protocol = "TCP"
  type     = "${var.use_internal_lb ? "INTERNAL" : "EXTERNAL"}"
  ports    = [80, 443]

  source_ranges = [
    "${var.pas_cidr}",
    "${var.services_cidr}",
  ]

  target_tags = ["${var.env_name}-tcp-router-lb"]

  health_check_path = "/health"
  health_check_port = "80"

  zones = "${var.zones}"

  network         = "${var.network}"
  subnetwork_name = "${google_compute_subnetwork.pas.name}"
}

module "tcp-lb" {
  source = "../lb"

  name     = "${var.env_name}-tcp-lb"
  protocol = "TCP"
  type     = "${var.use_internal_lb ? "INTERNAL" : "EXTERNAL"}"
  ports    = [1024, 1025, 1026, 1027, 1028]

  source_ranges = [
    "${var.pas_cidr}",
    "${var.services_cidr}",
  ]

  health_check_port = "80"

  target_tags = ["${var.env_name}-tcp-lb"]

  zones = "${var.zones}"

  network         = "${var.network}"
  subnetwork_name = "${google_compute_subnetwork.pas.name}"
}

module "ssh-lb" {
  source = "../lb"

  name     = "${var.env_name}-ssh-lb"
  protocol = "TCP"
  type     = "${var.use_internal_lb ? "INTERNAL" : "EXTERNAL"}"
  ports    = [2222]

  source_ranges = [
    "${var.pas_cidr}",
    "${var.services_cidr}",
  ]

  health_check_port = "2222"

  target_tags = ["${var.env_name}-ssh-lb"]

  zones = "${var.zones}"

  network         = "${var.network}"
  subnetwork_name = "${google_compute_subnetwork.pas.name}"
}
