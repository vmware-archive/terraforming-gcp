provider "google" {
  project     = "${var.project}"
  region      = "${var.region}"
  credentials = "${var.service_account_key}"

  version = ">= 1.7.0"
}

terraform {
  required_version = "< 0.12.0"
}

module "infra" {
  source = "../modules/infra"

  project                              = "${var.project}"
  env_name                             = "${var.env_name}"
  region                               = "${var.region}"
  infrastructure_cidr                  = "${var.infrastructure_cidr}"
  dns_suffix                           = "${var.dns_suffix}"
  internetless                         = "${var.internetless}"
  create_blobstore_service_account_key = "${var.create_blobstore_service_account_key}"
  internal_access_source_ranges        = ["${var.pas_cidr}", "${var.services_cidr}"]
}

module "ops_manager" {
  source = "../modules/ops_manager"

  project  = "${var.project}"
  env_name = "${var.env_name}"
  zones    = "${var.zones}"

  opsman_storage_bucket_count = "${var.opsman_storage_bucket_count}"

  opsman_machine_type                = "${var.opsman_machine_type}"
  opsman_image_url                   = "${var.opsman_image_url}"
  optional_opsman_image_url          = "${var.optional_opsman_image_url}"
  create_iam_service_account_members = "${var.create_iam_service_account_members}"

  pcf_network_name = "${module.infra.network}"
  subnet           = "${module.infra.subnet}"

  dns_zone_name     = "${module.infra.dns_zone_name}"
  dns_zone_dns_name = "${module.infra.dns_zone_dns_name}"

  sql_instance       = "${module.external_database.sql_instance}"
  opsman_sql_db_host = "${var.opsman_sql_db_host}"
}

module "pas_certs" {
  source = "../modules/certs"

  subdomains    = ["*.apps", "*.sys"] # Should we add support for multi-tenant UAA by adding: "*.login.sys", "*.uaa.sys"
  env_name      = "${var.env_name}"
  dns_suffix    = "${var.dns_suffix}"
  resource_name = "pas-lbcert"

  ssl_cert           = "${var.ssl_cert}"
  ssl_private_key    = "${var.ssl_private_key}"
  ssl_ca_cert        = "${var.ssl_ca_cert}"
  ssl_ca_private_key = "${var.ssl_ca_private_key}"
}

module "pas" {
  source = "../modules/pas"

  project            = "${var.project}"
  env_name           = "${var.env_name}"
  region             = "${var.region}"
  zones              = "${var.zones}"
  pas_cidr           = "${var.pas_cidr}"
  services_cidr      = "${var.services_cidr}"
  internetless       = "${var.internetless}"
  global_lb          = "${var.global_lb}"
  create_gcs_buckets = "${var.create_gcs_buckets}"
  buckets_location   = "${var.buckets_location}"

  network           = "${module.infra.network}"
  dns_zone_name     = "${module.infra.dns_zone_name}"
  dns_zone_dns_name = "${module.infra.dns_zone_dns_name}"
  ssl_certificate   = "${module.pas_certs.ssl_certificate}"

  sql_instance    = "${module.external_database.sql_instance}"
  pas_sql_db_host = "${var.pas_sql_db_host}"
}

# Optional

module "isoseg_certs" {
  source = "../modules/certs"

  subdomains    = ["*.iso"]
  env_name      = "${var.env_name}"
  dns_suffix    = "${var.dns_suffix}"
  resource_name = "isoseg-lbcert"

  ssl_cert           = "${var.iso_seg_ssl_cert}"
  ssl_private_key    = "${var.iso_seg_ssl_private_key}"
  ssl_ca_cert        = "${var.iso_seg_ssl_ca_cert}"
  ssl_ca_private_key = "${var.iso_seg_ssl_ca_private_key}"
}

module "isolation_segment" {
  source = "../modules/isolation_segment"

  count = "${var.isolation_segment ? 1 : 0}"

  env_name          = "${var.env_name}"
  zones             = "${var.zones}"
  internetless      = "${var.internetless}"
  dns_zone_dns_name = "${var.env_name}.${var.dns_suffix}"

  dns_zone_name            = "${module.infra.dns_zone_name}"
  public_health_check_link = "${module.pas.cf_public_health_check}"
  pas_subnet_cidr          = "${module.pas.pas_subnet_ip_cidr_range}"
  ssl_certificate          = "${module.isoseg_certs.ssl_certificate}"
}

module "external_database" {
  source = "../modules/external_database"

  create = "${var.external_database}"

  env_name    = "${var.env_name}"
  region      = "${var.region}"
  sql_db_tier = "db-n1-standard-1"
}

module "internetless" {
  source = "../modules/internetless"

  env_name     = "${var.env_name}"
  internetless = "${var.internetless}"
  network      = "${module.infra.network}"

  egress_target_account = "${module.ops_manager.service_account_email}"

  internal_cidr_ranges = [
    "${module.infra.ip_cidr_range}",
    "${module.pas.pas_subnet_ip_cidr_range}",
    "${module.pas.services_subnet_ip_cidr_range}",
  ]
}
