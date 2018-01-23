// Allow access to master node
resource "google_compute_firewall" "pks-master" {
  name    = "${var.env_name}-pks-master"
  network = "${var.network_name}"

  allow {
    protocol = "tcp"
    ports    = ["8443"]
  }

  target_tags = ["master"]
}
