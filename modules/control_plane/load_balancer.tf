resource "google_compute_target_pool" "control-plane" {
  name = "${var.env_name}-control-plane"

  session_affinity = "NONE"
}

resource "google_compute_forwarding_rule" "worker-gateway" {
  name        = "${var.env_name}-control-plane-worker-gw"
  target      = "${google_compute_target_pool.control-plane.self_link}"
  port_range  = "2222"
  ip_protocol = "TCP"
  ip_address  = "${google_compute_address.control-plane.address}"
}

resource "google_compute_forwarding_rule" "atc" {
  name        = "${var.env_name}-control-plane-atc"
  target      = "${google_compute_target_pool.control-plane.self_link}"
  port_range  = "443"
  ip_protocol = "TCP"
  ip_address  = "${google_compute_address.control-plane.address}"
}

resource "google_compute_forwarding_rule" "uaa" {
  name        = "${var.env_name}-control-plane-uaa"
  target      = "${google_compute_target_pool.control-plane.self_link}"
  port_range  = "8443"
  ip_protocol = "TCP"
  ip_address  = "${google_compute_address.control-plane.address}"
}

resource "google_compute_firewall" "control-plane" {
  name    = "${var.env_name}-control-plane-open"
  network = "${var.network_name}"

  allow {
    protocol = "tcp"
    ports    = ["443", "2222", "8443"]
  }

  target_tags = ["${var.env_name}-control-plane"]
}

resource "google_compute_address" "control-plane" {
  name = "${var.env_name}-control-plane"
}

resource "google_dns_record_set" "control-plane" {
  name = "plane.${var.dns_zone_dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = "${var.dns_zone_name}"

  rrdatas = ["${google_compute_address.control-plane.address}"]
}
