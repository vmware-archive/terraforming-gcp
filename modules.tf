module "external_database" {
  source = "./external_database"

  count = "${var.external_database ? 1 : 0}"

  env_name    = "${var.env_name}"
  region      = "${var.region}"
  sql_db_tier = "db-f1-micro"

  pas_sql_db_host    = "${var.pas_sql_db_host}"
  opsman_sql_db_host = "${var.opsman_sql_db_host}"
}

module "isolation_segment" {
  source = "./isolation_segment"

  count = "${var.isolation_segment ? 1 : 0}"

  env_name = "${var.env_name}"
  zones    = "${var.zones}"

  ssl_cert        = "${var.iso_seg_ssl_cert}"
  ssl_private_key = "${var.iso_seg_ssl_private_key}"

  ssl_ca_cert        = "${var.iso_seg_ssl_ca_cert}"
  ssl_ca_private_key = "${var.iso_seg_ssl_ca_private_key}"

  dns_zone_name           = "${google_dns_managed_zone.env_dns_zone.name}"
  dns_zone_dns_name       = "${var.env_name}.${var.dns_suffix}"
  public_healthcheck_link = "${google_compute_http_health_check.cf-public.self_link}"
}

module "pks" {
  source = "./pks"

  count = "${var.pks ? 1 : 0}"

  pks_cidr          = "${var.pks_cidr}"
  pks_services_cidr = "${var.pks_services_cidr}"

  env_name     = "${var.env_name}"
  network_name = "${google_compute_network.pcf-network.name}"
  zones        = "${var.zones}"
  region       = "${var.region}"

  dns_zone_name     = "${google_dns_managed_zone.env_dns_zone.name}"
  dns_zone_dns_name = "${var.env_name}.${var.dns_suffix}"
}
