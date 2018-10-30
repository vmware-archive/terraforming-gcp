resource "google_dns_record_set" "ops-manager-dns" {
  name = "pcf.${var.dns_zone_dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = "${var.dns_zone_name}"

  rrdatas = ["${google_compute_address.ops-manager-ip.address}"]
}

resource "google_dns_record_set" "optional-ops-manager-dns" {
  name  = "pcf-optional.${var.dns_zone_dns_name}"
  type  = "A"
  ttl   = 300
  count = "${min(length(split("", var.optional_opsman_image_url)),1)}"

  managed_zone = "${var.dns_zone_name}"

  rrdatas = ["${google_compute_address.optional-ops-manager-ip.address}"]
}
