resource "google_compute_firewall" "isoseg-cf-internal" {
  name     = "${var.env_name}-isoseg-cf-internal"
  network  = "${var.network_name}"
  count    = "${var.count}"
  priority = 997

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  source_tags = ["isoseg-${var.env_name}"]
  target_tags = ["isoseg-${var.env_name}"]
}

resource "google_compute_firewall" "isoseg-cf-ingress" {
  name    = "${var.env_name}-isoseg-cf-ingress"
  network = "${var.network_name}"
  count   = "${var.count}"

  direction     = "INGRESS"
  source_ranges = ["${var.pas_subnet_cidr}"]
  target_tags   = ["isoseg-${var.env_name}"]
  priority      = 998

  allow {
    protocol = "tcp"
    ports    = ["1801", "8853"]
  }
}

resource "google_compute_firewall" "isoseg-block-everything-ingress" {
  name    = "${var.env_name}-isoseg-block-cf-ingress"
  network = "${var.network_name}"
  count   = "${var.count}"

  direction     = "INGRESS"
  source_ranges = ["${var.pas_subnet_cidr}"]
  target_tags   = ["isoseg-${var.env_name}"]
  priority      = 999

  deny {
    protocol = "icmp"
  }

  deny {
    protocol = "tcp"
  }

  deny {
    protocol = "udp"
  }
}

resource "google_compute_firewall" "isoseg-cf-egress" {
  name    = "${var.env_name}-isoseg-cf-egress"
  network = "${var.network_name}"
  count   = "${var.count}"

  direction          = "EGRESS"
  destination_ranges = ["${var.pas_subnet_cidr}"]
  target_tags        = ["isoseg-${var.env_name}"]

  allow {
    protocol = "tcp"

    ports = [
      "9090",
      "9091",
      "8082",
      "8300",
      "8301",
      "8302",
      "8889",
      "8443",
      "3000",
      "4443",
      "8080",
      "3457",
      "9023",
      "9022",
      "4222",
      "8844",
      "8853",
    ]
  }

  allow {
    protocol = "udp"
    ports    = ["8301", "8302", "8600"]
  }
}
