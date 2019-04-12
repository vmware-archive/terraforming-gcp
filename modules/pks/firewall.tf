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

# allow external access for master node(s)
resource "google_compute_firewall" "pks-external" {
  name    = "${var.env_name}-pks-external"
  network = "${var.network_name}"

  direction = "EGRESS"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  destination_ranges = ["0.0.0.0/0"]
  target_tags        = ["master"]
}
