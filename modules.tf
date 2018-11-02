module "external_database" {
  source = "./external_database"

  count = "${var.external_database ? 1 : 0}"

  env_name    = "${var.env_name}"
  region      = "${var.region}"
  sql_db_tier = "db-n1-standard-1"

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
  project      = "${var.project}"

  dns_zone_name     = "${google_dns_managed_zone.env_dns_zone.name}"
  dns_zone_dns_name = "${var.env_name}.${var.dns_suffix}"
}

module "jumpbox" {
  source = "./jumpbox"

  count = "${var.jumpbox ? 1 : 0}"

  dns_suffix        = "${var.dns_suffix}"
  availability_zone = "${var.zones[0]}"
  subnet_name       = "${google_compute_subnetwork.management-subnet.name}"

  jumpbox_init_script   = "${var.jumpbox_init_script}"
  jumpbox_pub_key       = "${format("ubuntu:%s", tls_private_key.ops-manager.public_key_openssh)}"
  jumpbox_priv_key      = "${tls_private_key.ops-manager.private_key_pem}"
  env_name              = "${var.env_name}"
  username              = "ubuntu"
  pcf_network_name      = "${google_compute_network.pcf-network.name}"
  pcf_managed_zone_name = "${google_dns_managed_zone.env_dns_zone.name}"
}
