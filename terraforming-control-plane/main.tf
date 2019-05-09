provider "google" {
  project     = "${var.project}"
  region      = "${var.region}"
  credentials = "${var.service_account_key}"

  version = "~> 1.20"
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
  internal_access_source_ranges        = ["${var.control_plane_cidr}"]
}

module "acme_cert" {
  source              = "../modules/acme_cert"
  project             = "${var.project}"
  service_account_key = "${var.service_account_key}"
  common_name         = "${var.env_name}.${var.dns_suffix}"
  registration_email  = "${var.registration_email}"
  sans                = ["uaa.${var.env_name}.${var.dns_suffix}", "credhub.${var.env_name}.${var.dns_suffix}"]
}

module "ops_manager" {
  source = "../modules/ops_manager"

  project  = "${var.project}"
  env_name = "${var.env_name}"
  zones    = "${var.zones}"

  opsman_storage_bucket_count        = "${var.opsman_storage_bucket_count}"
  create_iam_service_account_members = "${var.create_iam_service_account_members}"
  opsman_machine_type                = "${var.opsman_machine_type}"
  opsman_image_url                   = "${var.opsman_image_url}"
  optional_opsman_image_url          = "${var.optional_opsman_image_url}"

  pcf_network_name  = "${module.infra.network}"
  subnet            = "${module.infra.subnet}"
  dns_zone_dns_name = "${module.infra.dns_zone_dns_name}"
  dns_zone_name     = "${module.infra.dns_zone_name}"

  sql_instance       = "${module.external_database.sql_instance}"
  opsman_sql_db_host = "${var.opsman_sql_db_host}"
}

module "control_plane" {
  source = "../modules/control_plane"

  env_name           = "${var.env_name}"
  zones              = "${var.zones}"
  region             = "${var.region}"
  project            = "${var.project}"
  control_plane_cidr = "${var.control_plane_cidr}"

  network           = "${module.infra.network}"
  dns_zone_name     = "${module.infra.dns_zone_name}"
  dns_zone_dns_name = "${module.infra.dns_zone_dns_name}"

  lb_cert_pem        = "${module.acme_cert.cert_pem}"
  lb_private_key_pem = "${module.acme_cert.private_key_pem}"
}

# Optional

module "external_database" {
  source = "../modules/external_database"

  create = "${var.external_database}"

  env_name    = "${var.env_name}"
  region      = "${var.region}"
  sql_db_tier = "db-n1-standard-1"
}
