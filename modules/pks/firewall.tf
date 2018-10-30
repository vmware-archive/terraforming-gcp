// Allow access to master nodes
resource "google_compute_firewall" "pks-master" {
  name    = "${var.env_name}-pks-master"
  network = "${var.network_name}"

  allow {
    protocol = "tcp"
    ports    = ["8443"]
  }

  target_tags = ["master"]
}

// Allow access to PKS API
resource "google_compute_firewall" "pks-api" {
  name    = "${var.env_name}-pks-api"
  network = "${var.network_name}"

  allow {
    protocol = "tcp"
    ports    = ["9021", "8443"]
  }

  target_tags = ["${var.env_name}-pks-api"]
}

// Allow open access between internal VMs for a PKS deployment
resource "google_compute_firewall" "pks-internal" {
  name    = "${var.env_name}-pks-internal"
  network = "${var.network_name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  source_ranges = [
    "${google_compute_subnetwork.pks-subnet.ip_cidr_range}",
    "${google_compute_subnetwork.pks-services-subnet.ip_cidr_range}",
  ]
}
