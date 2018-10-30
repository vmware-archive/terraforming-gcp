resource "google_dns_record_set" "wildcard-pks-dns" {
  name = "*.pks.${var.dns_zone_dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = "${var.dns_zone_name}"

  rrdatas = ["${google_compute_address.pks-api.address}"]
}
