resource "google_dns_record_set" "control-plane" {
  name = "plane.${var.dns_zone_dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = "${var.dns_zone_name}"

  rrdatas = ["${module.plane-lb.address}"]
}

resource "google_dns_record_set" "uaa" {
  name = "uaa.${var.dns_zone_dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = "${var.dns_zone_name}"

  rrdatas = ["${google_compute_global_address.https_lb_uaa.address}"]
}

resource "google_dns_record_set" "credhub" {
  name = "credhub.${var.dns_zone_dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = "${var.dns_zone_name}"

  rrdatas = ["${google_compute_global_address.https_lb_credhub.address}"]
}
