resource "google_compute_subnetwork" "pks-subnet" {
  name          = "${var.env_name}-pks-subnet"
  ip_cidr_range = "${var.pks_cidr}"
  network       = "${var.network_name}"
  region        = "${var.region}"
}

resource "google_compute_subnetwork" "pks-services-subnet" {
  name          = "${var.env_name}-pks-services-subnet"
  ip_cidr_range = "${var.pks_services_cidr}"
  network       = "${var.network_name}"
  region        = "${var.region}"
}
