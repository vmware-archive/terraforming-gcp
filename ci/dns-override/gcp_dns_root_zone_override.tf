resource "google_dns_record_set" "name_servers" {
  name = "${var.env_name}.${var.dns_suffix}."
  type = "NS"
  ttl  = 60

  managed_zone = "${var.top_level_zone_name}"

  rrdatas = ["${module.infra.dns_zone_name_servers}"]
}

variable "top_level_zone_name" {
  description = "top level gcp zone name that NS records will be added to"
}
