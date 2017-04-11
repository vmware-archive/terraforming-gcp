module "external_database" {
  source = "./external_database"

  count = "${var.external_database ? 1 : 0}"

  env_name    = "${var.env_name}"
  region      = "${var.region}"
  sql_db_tier = "db-f1-micro"

  ert_sql_db_host    = "${var.ert_sql_db_host}"
  opsman_sql_db_host = "${var.opsman_sql_db_host}"
}
