resource "google_compute_network" "pcf-network" {
  name = "${var.env_name}-pcf-network"
}

resource "google_compute_subnetwork" "ops-manager-subnet" {
  name          = "${var.env_name}-ops-manager-subnet"
  ip_cidr_range = "10.0.0.0/24"
  network       = "${google_compute_network.pcf-network.self_link}"
  region        = "${var.region}"
}

resource "google_compute_subnetwork" "cf-subnet" {
  name          = "${var.env_name}-cf-subnet"
  ip_cidr_range = "10.0.1.0/24"
  network       = "${google_compute_network.pcf-network.self_link}"
  region        = "${var.region}"
}
