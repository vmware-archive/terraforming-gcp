// Allow access to TCP router
resource "google_compute_firewall" "cf-tcp" {
  name    = "${var.env_name}-cf-tcp"
  network = "${var.network}"

  allow {
    protocol = "tcp"
    ports    = ["1024-65535"]
  }

  target_tags = ["${var.env_name}-cf-tcp"]
}

// Static IP address for forwarding rule
resource "google_compute_address" "cf-tcp" {
  name = "${var.env_name}-cf-tcp"
}

// Health check
resource "google_compute_http_health_check" "cf-tcp" {
  name                = "${var.env_name}-cf-tcp"
  port                = 80
  request_path        = "/health"
  check_interval_sec  = 30
  timeout_sec         = 5
  healthy_threshold   = 10
  unhealthy_threshold = 2
}

// TCP target pool
resource "google_compute_target_pool" "cf-tcp" {
  name = "${var.env_name}-cf-tcp"

  health_checks = [
    "${google_compute_http_health_check.cf-tcp.name}",
  ]
}

// TCP forwarding rule
resource "google_compute_forwarding_rule" "cf-tcp" {
  name        = "${var.env_name}-cf-tcp"
  target      = "${google_compute_target_pool.cf-tcp.self_link}"
  port_range  = "1024-1123"
  ip_protocol = "TCP"
  ip_address  = "${google_compute_address.cf-tcp.address}"
}
