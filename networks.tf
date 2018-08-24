resource "google_compute_network" "pcf-network" {
  name = "${var.env_name}-pcf-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "infrastructure-subnet" {
  name          = "${var.env_name}-infrastructure-subnet"
  ip_cidr_range = "${var.infrastructure_cidr}"
  network       = "${google_compute_network.pcf-network.self_link}"
  region        = "${var.region}"
}

resource "google_compute_subnetwork" "pas-subnet" {
  name          = "${var.env_name}-pas-subnet"
  ip_cidr_range = "${var.pas_cidr}"
  network       = "${google_compute_network.pcf-network.self_link}"
  region        = "${var.region}"
}

resource "google_compute_subnetwork" "services-subnet" {
  name          = "${var.env_name}-services-subnet"
  ip_cidr_range = "${var.services_cidr}"
  network       = "${google_compute_network.pcf-network.self_link}"
  region        = "${var.region}"
}
