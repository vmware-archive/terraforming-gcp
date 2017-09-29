module "external_database" {
  source = "./external_database"

  count = "${var.external_database ? local.pcf_count : 0}"

  env_name    = "${var.env_name}"
  region      = "${var.region}"
  sql_db_tier = "db-f1-micro"

  ert_sql_db_host    = "${var.ert_sql_db_host}"
  opsman_sql_db_host = "${var.opsman_sql_db_host}"
}

module "isolation_segment" {
  source = "./isolation_segment"

  count = "${var.isolation_segment ? local.pcf_count : 0}"

  env_name = "${var.env_name}"
  zones    = "${var.zones}"

  ssl_cert             = "${var.iso_seg_ssl_cert}"
  ssl_cert_private_key = "${var.iso_seg_ssl_cert_private_key}"

  dns_zone_name           = "${google_dns_managed_zone.env_dns_zone.name}"
  dns_zone_dns_name       = "${google_dns_managed_zone.env_dns_zone.dns_name}"
  public_healthcheck_link = "${google_compute_http_health_check.cf-public.self_link}"
}

module "bbl" {
  source = "./bbl"
  count = "${var.bbl_config ? 1 : 0}"

  service_account_key = "${var.service_account_key}"
  env_id = "${var.env_name}"
  region = "${var.region}"
  zone = "${var.zones[0]}"
  project_id = "${var.project}"

  system_domain = "${var.dns_suffix}"
  ssl_certificate = "${var.ssl_cert}"
  ssl_certificate_private_key = "${var.ssl_cert_private_key}"

  cf_lb_count = "${var.bbl_cf_lb ? var.bbl_config : 0}"
  concourse_lb_count = "${var.bbl_concourse_lb ? var.bbl_config : 0}"
}
