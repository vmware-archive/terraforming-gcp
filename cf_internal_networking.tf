// Allow open access between internal VMs for a PCF deployment
resource "google_compute_firewall" "cf-internal" {
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

  target_tags = ["${var.env_name}-vms"]

  source_tags = [
    "${var.env_name}-vms",                  // Allows VMs deployed by OpsMan to talk to one another
    "${var.env_name}-ops-manager-external",
  ] // Allows bosh-init running on the OpsMan VM to SSH to the deployed BOSH Director
}
