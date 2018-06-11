// Allow ingress between internal VMs for a PCF deployment
resource "google_compute_firewall" "cf-internal-ingress" {
  count = "${var.internetless ? 1 : 0}"

  name    = "${var.env_name}-cf-internal-ingress"
  network = "${google_compute_network.pcf-network.name}"

  priority = 900

  direction = "INGRESS"

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
    "${google_compute_subnetwork.pas-subnet.ip_cidr_range}",
    "${google_compute_subnetwork.services-subnet.ip_cidr_range}",
  ]
}

// Allow egress between internal VMs for a PCF deployment
resource "google_compute_firewall" "cf-internal-egress" {
  count = "${var.internetless ? 1 : 0}"

  name    = "${var.env_name}-cf-internal-egress"
  network = "${google_compute_network.pcf-network.name}"

  priority = 1000

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

  destination_ranges = [
    "${google_compute_subnetwork.management-subnet.ip_cidr_range}",
    "${google_compute_subnetwork.pas-subnet.ip_cidr_range}",
    "${google_compute_subnetwork.services-subnet.ip_cidr_range}",
  ]
}

// Allow OpsMgr and BOSH Director to talk to GCP APIs, e.g. googleapis.com
resource "google_compute_firewall" "cf-allow-external-egress" {
  count = "${var.internetless ? 1 : 0}"

  name    = "${var.env_name}-cf-allow-external-egress"
  network = "${google_compute_network.pcf-network.name}"

  priority = 1100

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

  target_service_accounts = ["${google_service_account.opsman_service_account.email}"]

  destination_ranges = ["0.0.0.0/0"]
}

// Deny all outbound internet traffic
resource "google_compute_firewall" "cf-deny-external-egress" {
  count = "${var.internetless ? 1 : 0}"

  name    = "${var.env_name}-cf-deny-external-egress"
  network = "${google_compute_network.pcf-network.name}"

  priority = 1200

  direction = "EGRESS"

  deny {
    protocol = "icmp"
  }

  deny {
    protocol = "tcp"
  }

  deny {
    protocol = "udp"
  }

  destination_ranges = ["0.0.0.0/0"]
}
