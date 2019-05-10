resource "google_dns_record_set" "name_servers" {
  count = "${var.top_level_zone_name == "" ? 0 : 1}"
  name  = "${var.zone_name}."
  type  = "NS"
  ttl   = 60

  managed_zone = "${var.top_level_zone_name}"

  rrdatas = ["${var.name_servers}"]
}
