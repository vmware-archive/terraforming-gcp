// Modify dns records to resolve to the ha proxy when in internetless mode.
locals {
  haproxy_static_ip = "${cidrhost(google_compute_subnetwork.pas.ip_cidr_range, -20)}"
  cf_address        = "${var.global_lb > 0 ? element(concat(google_compute_global_address.cf.*.address, list("")), 0) : element(concat(google_compute_address.cf.*.address, list("")), 0)}"
  cf_ws_address     = "${var.global_lb > 0 ? element(concat(google_compute_address.cf_ws.*.address, list("")), 0) : element(concat(google_compute_address.cf.*.address, list("")), 0)}"
}

resource "google_dns_record_set" "wildcard-sys-dns" {
  name = "*.sys.${var.dns_zone_dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = "${var.dns_zone_name}"

  rrdatas = ["${var.internetless ? local.haproxy_static_ip : local.cf_address}"]
}

resource "google_dns_record_set" "doppler-sys-dns" {
  name = "doppler.sys.${var.dns_zone_dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = "${var.dns_zone_name}"

  rrdatas = ["${var.internetless ? local.haproxy_static_ip : local.cf_ws_address}"]
}

resource "google_dns_record_set" "loggregator-sys-dns" {
  name = "loggregator.sys.${var.dns_zone_dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = "${var.dns_zone_name}"

  rrdatas = ["${var.internetless ? local.haproxy_static_ip : local.cf_ws_address}"]
}

resource "google_dns_record_set" "wildcard-apps-dns" {
  name = "*.apps.${var.dns_zone_dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = "${var.dns_zone_name}"

  rrdatas = ["${var.internetless ? local.haproxy_static_ip : local.cf_address}"]
}

resource "google_dns_record_set" "wildcard-ws-dns" {
  name = "*.ws.${var.dns_zone_dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = "${var.dns_zone_name}"

  rrdatas = ["${var.internetless ? local.haproxy_static_ip : local.cf_ws_address}"]
}

resource "google_dns_record_set" "app-ssh-dns" {
  name = "ssh.sys.${var.dns_zone_dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = "${var.dns_zone_name}"

  rrdatas = ["${var.internetless ? local.haproxy_static_ip : google_compute_address.cf-ssh.address}"]
}

resource "google_dns_record_set" "tcp-dns" {
  name = "tcp.${var.dns_zone_dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = "${var.dns_zone_name}"

  rrdatas = ["${var.internetless ? local.haproxy_static_ip : google_compute_address.cf-tcp.address}"]
}
