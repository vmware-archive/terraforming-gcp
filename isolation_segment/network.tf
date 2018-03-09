resource "google_compute_subnetwork" "isoseg-subnet" {
  count         = "${var.count}"
  name          = "${var.env_name}-isoseg-subnet"
  ip_cidr_range = "${var.subnet_cidr}"
  network       = "${var.network_name}"
  region        = "${var.region}"
}
