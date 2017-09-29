resource "google_compute_network" "pcf-network" {
  count = "${local.pcf_count}"
  name = "${var.env_name}-pcf-network"
}

resource "google_compute_subnetwork" "management-subnet" {
  count = "${local.pcf_count}"
  name          = "${var.env_name}-management-subnet"
  ip_cidr_range = "${var.management_cidr}"
  network       = "${google_compute_network.pcf-network.self_link}"
  region        = "${var.region}"
}

resource "google_compute_subnetwork" "ert-subnet" {
  count = "${local.pcf_count}"
  name          = "${var.env_name}-ert-subnet"
  ip_cidr_range = "${var.ert_cidr}"
  network       = "${google_compute_network.pcf-network.self_link}"
  region        = "${var.region}"
}

resource "google_compute_subnetwork" "services-subnet" {
  count = "${local.pcf_count}"
  name          = "${var.env_name}-services-subnet"
  ip_cidr_range = "${var.services_cidr}"
  network       = "${google_compute_network.pcf-network.self_link}"
  region        = "${var.region}"
}
