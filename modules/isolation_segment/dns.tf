locals {
  haproxy_static_ip = "${cidrhost(var.pas_subnet_cidr, -19)}"
}

resource "google_dns_record_set" "wildcard-iso-dns" {
  name  = "*.iso.${var.dns_zone_dns_name}."
  type  = "A"
  ttl   = 300
  count = "${var.count}"

  managed_zone = "${var.dns_zone_name}"

  rrdatas = ["${var.internetless ? local.haproxy_static_ip : google_compute_global_address.isoseg.address}"]
}
