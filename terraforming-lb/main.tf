provider "google" {
  project     = "${var.project}"
  region      = "${var.region}"
  credentials = "${var.service_account_key}"

  version = ">= 1.7.0"
}

terraform {
  required_version = "< 0.12.0"
}

module "router-lb" {
  source = "../modules/lb"

  name     = "router-lb"
  protocol = "TCP"
  type     = "${var.use_internal_lb ? "INTERNAL" : "EXTERNAL"}"
  ports    = [80, 443]

  source_tags = [
    "router-lb",
  ]

  target_tags = [
    "router-lb",
  ]

  health_check_path = "/health"
  health_check_port = "8080"

  zones = "${var.zones}"

  network         = "pas"
  subnetwork_name = "pas"
}

module "ssh-lb" {
  source = "../modules/lb"

  name     = "ssh-lb"
  protocol = "TCP"
  type     = "${var.use_internal_lb ? "INTERNAL" : "EXTERNAL"}"
  ports    = [2222]

  source_tags = [
    "ssh-lb",
  ]

  target_tags = [
    "ssh-lb",
  ]

  zones = "${var.zones}"

  network         = "pas"
  subnetwork_name = "pas"
}
