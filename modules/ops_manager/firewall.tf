# Allow HTTP/S access to Ops Manager from the outside world
resource "google_compute_firewall" "ops-manager-external" {
  name        = "${var.env_name}-ops-manager-external"
  network     = "${var.pcf_network_name}"
  target_tags = ["${var.env_name}-ops-manager-external"]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }
}
