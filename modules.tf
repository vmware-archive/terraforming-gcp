module "external_database" {
  source = "./external_database"

  count = "${var.external_database ? 1 : 0}"

  env_name    = "${var.env_name}"
  region      = "${var.region}"
  sql_db_tier = "db-f1-micro"

  external_database_ert_sql_db_host        = "${var.ert_sql_db_host}"
  external_database_ert_sql_db_username    = "${var.ert_sql_db_username}"
  external_database_ert_sql_db_password    = "${var.ert_sql_db_password}"
  external_database_opsman_sql_db_host     = "${var.opsman_sql_db_host}"
  external_database_opsman_sql_db_username = "${var.opsman_sql_db_username}"
  external_database_opsman_sql_db_password = "${var.opsman_sql_db_password}"
}
