// Allow access to master nodes
resource "google_compute_firewall" "pks-master" {
  name    = "${var.env_name}-pks-master"
  count   = "${var.count}"
  network = "${var.network_name}"

  allow {
    protocol = "tcp"
    ports    = ["8443"]
  }

  target_tags = ["master", "${var.env_name}-vms"]

  source_ranges = ["0.0.0.0/0"]
}

// Allow access to PKS API
resource "google_compute_firewall" "pks-api" {
  name    = "${var.env_name}-pks-api"
  count   = "${var.count}"
  network = "${var.network_name}"

  allow {
    protocol = "tcp"
    ports    = ["9021", "8443"]
  }

  target_tags = ["pivotal-container-service", "${var.env_name}-vms"]

  source_ranges = ["0.0.0.0/0"]
}

// Allow open access between internal VMs for a PKS deployment
resource "google_compute_firewall" "pks-internal" {
  name    = "${var.env_name}-pks-internal"
  count   = "${var.count}"
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
