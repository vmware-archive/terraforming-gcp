module "http-lb" {
  source = "../lb"

  name      = "${var.env_name}-http-lb"
  protocol  = "TCP"
  global_lb = "${var.global_lb}"
  type      = "${var.use_internal_lb ? "INTERNAL" : "EXTERNAL"}"
  ports     = [80, 443]

  source_ranges = [
    "${var.pas_cidr}",
    "${var.services_cidr}",
  ]

  target_tags = ["${var.env_name}-http-lb"]

  health_check_path = "/health"
  health_check_port = "8080"

  zones = "${var.zones}"

  network         = "${var.network}"
  subnetwork_name = "${google_compute_subnetwork.pas.name}"
}

module "ws-lb" {
  source = "../lb"

  name      = "${var.env_name}-ws-lb"
  protocol  = "TCP"
  global_lb = "${var.global_lb}"
  type      = "${var.use_internal_lb ? "INTERNAL" : "EXTERNAL"}"
  ports     = [80, 443]

  source_ranges = [
    "${var.pas_cidr}",
    "${var.services_cidr}",
  ]

  target_tags = ["${var.env_name}-ws-lb"]

  health_check_path = "/health"
  health_check_port = "8080"

  zones = "${var.zones}"

  network         = "${var.network}"
  subnetwork_name = "${google_compute_subnetwork.pas.name}"
}

module "tcp-lb" {
  source = "../lb"

  name      = "${var.env_name}-tcp-lb"
  protocol  = "TCP"
  global_lb = "${var.global_lb}"
  type      = "${var.use_internal_lb ? "INTERNAL" : "EXTERNAL"}"
  ports     = [1024, 1025, 1026, 1027, 1028]

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

  name      = "${var.env_name}-ssh-lb"
  protocol  = "TCP"
  global_lb = "${var.global_lb}"
  type      = "${var.use_internal_lb ? "INTERNAL" : "EXTERNAL"}"
  ports     = [2222]

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
