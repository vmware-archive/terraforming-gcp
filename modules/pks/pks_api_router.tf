// Static IP address for forwarding rule
resource "google_compute_address" "pks-api" {
  name = "${var.env_name}-pks-api"
}

// PKS target pool
resource "google_compute_target_pool" "pks-api" {
  name = "${var.env_name}-pks-api"

  health_checks = []
}

// TCP forwarding rules
resource "google_compute_forwarding_rule" "pks-api-9021" {
  name        = "${var.env_name}-pks-api-9021"
  target      = "${google_compute_target_pool.pks-api.self_link}"
  port_range  = "9021"
  ip_protocol = "TCP"
  ip_address  = "${google_compute_address.pks-api.address}"
}

resource "google_compute_forwarding_rule" "pks-api-8443" {
  name        = "${var.env_name}-pks-api-8443"
  target      = "${google_compute_target_pool.pks-api.self_link}"
  port_range  = "8443"
  ip_protocol = "TCP"
  ip_address  = "${google_compute_address.pks-api.address}"
}
