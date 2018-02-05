// Allow access to TCP router
resource "google_compute_firewall" "pks-api" {
  name    = "${var.env_name}-pks-api"
  network = "${var.network_name}"
  count   = "${var.count}"

  allow {
    protocol = "tcp"
    ports    = ["9021"]
  }

  target_tags = ["${var.env_name}-pks-api"]
}

// Static IP address for forwarding rule
resource "google_compute_address" "pks-api" {
  name  = "${var.env_name}-pks-api"
  count = "${var.count}"
}

// TCP target pool
resource "google_compute_target_pool" "pks-api" {
  name  = "${var.env_name}-pks-api"
  count = "${var.count}"

  health_checks = []
}

// TCP forwarding rule
resource "google_compute_forwarding_rule" "pks-api" {
  name        = "${var.env_name}-pks-api"
  target      = "${google_compute_target_pool.pks-api.self_link}"
  port_range  = "9021"
  ip_protocol = "TCP"
  ip_address  = "${google_compute_address.pks-api.address}"
  count       = "${var.count}"
}
