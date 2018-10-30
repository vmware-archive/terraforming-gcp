resource "google_compute_subnetwork" "pas" {
  name          = "${var.env_name}-pas-subnet"
  ip_cidr_range = "${var.pas_cidr}"
  network       = "${var.network}"
  region        = "${var.region}"
}

resource "google_compute_subnetwork" "services" {
  name          = "${var.env_name}-services-subnet"
  ip_cidr_range = "${var.services_cidr}"
  network       = "${var.network}"
  region        = "${var.region}"
}
