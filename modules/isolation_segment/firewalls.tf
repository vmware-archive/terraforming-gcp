/* This firewall allows traffic between VMs in the isolation segment. */
resource "google_compute_firewall" "isoseg-cf-internal" {
  count = "${var.count * var.with_firewalls}"

  name     = "${var.env_name}-isoseg-cf-internal"
  network  = "${var.network}"
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

/* This firewall allows traffic on certain ports from cf to the isolation segment. */
resource "google_compute_firewall" "isoseg-cf-ingress" {
  count = "${var.count * var.with_firewalls}"

  name    = "${var.env_name}-isoseg-cf-ingress"
  network = "${var.network}"

  source_ranges = ["${var.pas_subnet_cidr}"]
  target_tags   = ["isoseg-${var.env_name}"]
  priority      = 998

  allow {
    protocol = "tcp"
    ports    = ["1801", "8853"]
  }
}

/* This firewall denies traffic from cf to the isolation segment on all ports. */
resource "google_compute_firewall" "isoseg-block-cf-ingress" {
  count = "${var.count * var.with_firewalls}"

  name    = "${var.env_name}-isoseg-block-cf-ingress"
  network = "${var.network}"

  direction   = "INGRESS"
  source_tags = ["cf-${var.env_name}"]
  target_tags = ["isoseg-${var.env_name}"]
  priority    = 999

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

/* This firewall allows traffic on certain ports from the isolation segment to cf. */
resource "google_compute_firewall" "cf-isoseg-ingress" {
  count = "${var.count * var.with_firewalls}"

  name    = "${var.env_name}-cf-isoseg-ingress"
  network = "${var.network}"

  source_tags = ["isoseg-${var.env_name}"]
  target_tags = ["cf-${var.env_name}"]
  priority    = 998

  allow {
    protocol = "tcp"

    ports = [
      "3000",
      "3457",
      "4003",
      "4103",
      "4222",
      "4443",
      "8080",
      "8082",
      "8084",
      "8300",
      "8301",
      "8302",
      "8443",
      "8844",
      "8853",
      "8889",
      "8891",
      "9022",
      "9023",
      "9090",
      "9091",
    ]
  }

  allow {
    protocol = "udp"
    ports    = ["8301", "8302", "8600"]
  }
}

/* This firewall denies traffic from the isolation segment to cf on all ports. */
resource "google_compute_firewall" "cf-block-isoseg-ingress" {
  count = "${var.count}"

  name    = "${var.env_name}-cf-block-isoseg-ingress"
  network = "${var.network}"

  source_tags = ["isoseg-${var.env_name}"]
  target_tags = ["cf-${var.env_name}"]
  priority    = 999

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

/* This firewall allows ssh from the bosh director to the PAS subnet. */
resource "google_compute_firewall" "bosh-to-isoseg-allow" {
  count = "${var.count * var.with_firewalls}"

  name    = "${var.env_name}-bosh-to-isoseg-allow"
  network = "${var.network}"

  direction = "INGRESS"

  source_ranges = ["${var.infrastructure_subnet_cidr}"]
  target_tags   = ["isoseg-${var.env_name}"]
  priority      = 998

  allow {
    protocol = "tcp"

    ports = [
      "22",
    ]
  }
}

resource "google_compute_firewall" "bosh-to-isoseg-deny" {
  count = "${var.count * var.with_firewalls}"

  name    = "${var.env_name}-bosh-to-isoseg-deny"
  network = "${var.network}"

  direction = "INGRESS"

  source_ranges = ["${var.infrastructure_subnet_cidr}"]
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

/* This firewall allows some ports from PAS subnet to bosh director. */
resource "google_compute_firewall" "isoseg-to-bosh-allow" {
  count = "${var.count * var.with_firewalls}"

  name    = "${var.env_name}-isoseg-to-bosh-allow"
  network = "${var.network}"

  direction = "EGRESS"

  target_tags        = ["isoseg-${var.env_name}"]
  destination_ranges = ["${var.infrastructure_subnet_cidr}"]
  priority           = 998

  allow {
    protocol = "tcp"

    ports = [
      "4222",
      "25250",
      "25777",
    ]
  }
}

resource "google_compute_firewall" "isoseg-to-bosh-deny" {
  count = "${var.count * var.with_firewalls}"

  name    = "${var.env_name}-isoseg-to-bosh-deny"
  network = "${var.network}"

  direction = "EGRESS"

  target_tags        = ["isoseg-${var.env_name}"]
  destination_ranges = ["${var.infrastructure_subnet_cidr}"]
  priority           = 999

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
