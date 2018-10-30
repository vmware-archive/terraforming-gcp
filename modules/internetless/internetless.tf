// Allow ingress between internal VMs for a PCF deployment
resource "google_compute_firewall" "cf-internal-ingress" {
  count = "${var.internetless ? 1 : 0}"

  name    = "${var.env_name}-cf-internal-ingress"
  network = "${var.network}"

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

  source_ranges = "${var.internal_cidr_ranges}"
}

// Allow egress between internal VMs for a PCF deployment
resource "google_compute_firewall" "cf-internal-egress" {
  count = "${var.internetless ? 1 : 0}"

  name    = "${var.env_name}-cf-internal-egress"
  network = "${var.network}"

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

  destination_ranges = "${var.internal_cidr_ranges}"
}

// Allow OpsMgr and BOSH Director to talk to GCP APIs, e.g. googleapis.com
resource "google_compute_firewall" "cf-allow-external-egress" {
  count = "${var.internetless ? 1 : 0}"

  name    = "${var.env_name}-cf-allow-external-egress"
  network = "${var.network}"

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

  target_service_accounts = ["${var.egress_target_account}"]

  destination_ranges = ["0.0.0.0/0"]
}

// Deny all outbound internet traffic
resource "google_compute_firewall" "cf-deny-external-egress" {
  count = "${var.internetless ? 1 : 0}"

  name    = "${var.env_name}-cf-deny-external-egress"
  network = "${var.network}"

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
