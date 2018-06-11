resource "google_dns_managed_zone" "env_dns_zone" {
  name        = "${var.env_name}-zone"
  dns_name    = "${var.env_name}.${var.dns_suffix}."
  description = "DNS zone for the ${var.env_name} environment"
}

resource "google_dns_record_set" "ops-manager-dns" {
  name = "pcf.${google_dns_managed_zone.env_dns_zone.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = "${google_dns_managed_zone.env_dns_zone.name}"

  rrdatas = ["${google_compute_instance.ops-manager.network_interface.0.access_config.0.assigned_nat_ip}"]
}

resource "google_dns_record_set" "optional-ops-manager-dns" {
  name  = "pcf-optional.${google_dns_managed_zone.env_dns_zone.dns_name}"
  type  = "A"
  ttl   = 300
  count = "${min(length(split("", var.optional_opsman_image_url)),1)}"

  managed_zone = "${google_dns_managed_zone.env_dns_zone.name}"

  rrdatas = ["${google_compute_instance.optional-ops-manager.network_interface.0.access_config.0.assigned_nat_ip}"]
}

// Modify dns records to resolve to the ha proxy when in internetless mode.
locals {
  haproxy_static_ip = "${cidrhost(google_compute_subnetwork.pas-subnet.ip_cidr_range, -20)}"
}

resource "google_dns_record_set" "wildcard-sys-dns" {
  name = "*.sys.${google_dns_managed_zone.env_dns_zone.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = "${google_dns_managed_zone.env_dns_zone.name}"

  rrdatas = ["${var.internetless ? local.haproxy_static_ip : google_compute_global_address.cf.address}"]
}

resource "google_dns_record_set" "doppler-sys-dns" {
  name = "doppler.sys.${google_dns_managed_zone.env_dns_zone.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = "${google_dns_managed_zone.env_dns_zone.name}"

  rrdatas = ["${var.internetless ? local.haproxy_static_ip : google_compute_address.cf-ws.address}"]
}

resource "google_dns_record_set" "loggregator-sys-dns" {
  name = "loggregator.sys.${google_dns_managed_zone.env_dns_zone.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = "${google_dns_managed_zone.env_dns_zone.name}"

  rrdatas = ["${var.internetless ? local.haproxy_static_ip : google_compute_address.cf-ws.address}"]
}

resource "google_dns_record_set" "wildcard-apps-dns" {
  name = "*.apps.${google_dns_managed_zone.env_dns_zone.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = "${google_dns_managed_zone.env_dns_zone.name}"

  rrdatas = ["${var.internetless ? local.haproxy_static_ip : google_compute_global_address.cf.address}"]
}

resource "google_dns_record_set" "wildcard-ws-dns" {
  name = "*.ws.${google_dns_managed_zone.env_dns_zone.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = "${google_dns_managed_zone.env_dns_zone.name}"

  rrdatas = ["${var.internetless ? local.haproxy_static_ip : google_compute_address.cf-ws.address}"]
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
