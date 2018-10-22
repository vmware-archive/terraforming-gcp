resource "google_dns_managed_zone" "env_dns_zone" {
  name        = "${var.env_name}-zone"
  dns_name    = "${var.env_name}.${var.dns_suffix}."
  description = "DNS zone for the ${var.env_name} environment"
}

// Modify dns records to resolve to the ha proxy when in internetless mode.
locals {
  haproxy_static_ip = "${cidrhost(google_compute_subnetwork.pas-subnet.ip_cidr_range, -20)}"
  cf_address        = "${var.global_lb > 0 ? element(concat(google_compute_global_address.cf.*.address, list("")), 0) : element(concat(google_compute_address.cf.*.address, list("")), 0)}"
  cf_ws_address     = "${var.global_lb > 0 ? element(concat(google_compute_address.cf-ws.*.address, list("")), 0) : element(concat(google_compute_address.cf.*.address, list("")), 0)}"
}

resource "google_dns_record_set" "wildcard-sys-dns" {
  name = "*.sys.${google_dns_managed_zone.env_dns_zone.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = "${google_dns_managed_zone.env_dns_zone.name}"

  rrdatas = ["${var.internetless ? local.haproxy_static_ip : local.cf_address}"]
}

resource "google_dns_record_set" "doppler-sys-dns" {
  name = "doppler.sys.${google_dns_managed_zone.env_dns_zone.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = "${google_dns_managed_zone.env_dns_zone.name}"

  rrdatas = ["${var.internetless ? local.haproxy_static_ip : local.cf_ws_address}"]
}

resource "google_dns_record_set" "loggregator-sys-dns" {
  name = "loggregator.sys.${google_dns_managed_zone.env_dns_zone.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = "${google_dns_managed_zone.env_dns_zone.name}"

  rrdatas = ["${var.internetless ? local.haproxy_static_ip : local.cf_ws_address}"]
}

resource "google_dns_record_set" "wildcard-apps-dns" {
  name = "*.apps.${google_dns_managed_zone.env_dns_zone.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = "${google_dns_managed_zone.env_dns_zone.name}"

  rrdatas = ["${var.internetless ? local.haproxy_static_ip : local.cf_address}"]
}

resource "google_dns_record_set" "wildcard-ws-dns" {
  name = "*.ws.${google_dns_managed_zone.env_dns_zone.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = "${google_dns_managed_zone.env_dns_zone.name}"

  rrdatas = ["${var.internetless ? local.haproxy_static_ip : local.cf_ws_address}"]
}

resource "google_dns_record_set" "app-ssh-dns" {
  name = "ssh.sys.${google_dns_managed_zone.env_dns_zone.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = "${google_dns_managed_zone.env_dns_zone.name}"

  rrdatas = ["${var.internetless ? local.haproxy_static_ip : google_compute_address.cf-ssh.address}"]
}

resource "google_dns_record_set" "tcp-dns" {
  name = "tcp.${google_dns_managed_zone.env_dns_zone.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = "${google_dns_managed_zone.env_dns_zone.name}"

  rrdatas = ["${var.internetless ? local.haproxy_static_ip : google_compute_address.cf-tcp.address}"]
}
