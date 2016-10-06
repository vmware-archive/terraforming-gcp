// Allow access to HA Proxy
resource "google_compute_firewall" "cf-public" {
  name       = "${var.env_name}-cf-public"
  depends_on = ["google_compute_network.pcf-network"]
  network    = "${google_compute_network.pcf-network.name}"

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "4443", "2222"]
  }

  target_tags = ["${var.env_name}-cf-public"]
}

// Static IP address for forwarding rule
resource "google_compute_address" "cf" {
  name = "${var.env_name}-cf"
}

// Health check
resource "google_compute_http_health_check" "cf-public" {
  name                = "${var.env_name}-cf-public"
  host                = "api.sys.${google_dns_managed_zone.env_dns_zone.dns_name}"
  port                = 8080
  request_path        = "/health"
  check_interval_sec  = 30
  timeout_sec         = 5
  healthy_threshold   = 10
  unhealthy_threshold = 2
}

// Load balancing target pool
resource "google_compute_target_pool" "cf-public" {
  name = "${var.env_name}-cf-public"

  health_checks = [
    "${google_compute_http_health_check.cf-public.name}",
  ]
}

// HTTP forwarding rule
resource "google_compute_forwarding_rule" "cf-http" {
  name        = "${var.env_name}-cf-http"
  target      = "${google_compute_target_pool.cf-public.self_link}"
  port_range  = "80"
  ip_protocol = "TCP"
  ip_address  = "${google_compute_address.cf.address}"
}

// HTTP forwarding rule
resource "google_compute_forwarding_rule" "cf-https" {
  name        = "${var.env_name}-cf-https"
  target      = "${google_compute_target_pool.cf-public.self_link}"
  port_range  = "443"
  ip_protocol = "TCP"
  ip_address  = "${google_compute_address.cf.address}"
}

// WSS forwarding rule
resource "google_compute_forwarding_rule" "cf-wss" {
  name        = "${var.env_name}-cf-wss"
  target      = "${google_compute_target_pool.cf-public.self_link}"
  port_range  = "4443"
  ip_protocol = "TCP"
  ip_address  = "${google_compute_address.cf.address}"
}

// SSH forwarding rule
resource "google_compute_forwarding_rule" "cf-ssh" {
  name        = "${var.env_name}-cf-ssh"
  target      = "${google_compute_target_pool.cf-public.self_link}"
  port_range  = "2222"
  ip_protocol = "TCP"
  ip_address  = "${google_compute_address.cf.address}"
}
