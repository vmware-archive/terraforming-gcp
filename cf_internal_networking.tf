// Allow open access between internal VMs for a PCF deployment
resource "google_compute_firewall" "cf-internal" {
  count = "${local.pcf_count}"
  name    = "${var.env_name}-cf-internal"
  network = "${google_compute_network.pcf-network.name}"

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
    "${google_compute_subnetwork.management-subnet.ip_cidr_range}",
    "${google_compute_subnetwork.ert-subnet.ip_cidr_range}",
    "${google_compute_subnetwork.services-subnet.ip_cidr_range}",
  ]
}
