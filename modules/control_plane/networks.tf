resource "google_compute_subnetwork" "control-plane" {
  name          = "${var.env_name}-control-plane-subnet"
  ip_cidr_range = "${var.control_plane_cidr}"
  network       = "${var.network_name}"
  region        = "${var.region}"
}
