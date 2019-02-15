resource "google_dns_record_set" "control-plane" {
  name = "plane.${var.dns_zone_dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = "${var.dns_zone_name}"

  rrdatas = ["${module.plane-lb.address}"]
}
