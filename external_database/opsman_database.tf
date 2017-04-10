resource "google_sql_user" "opsman-user" {
  name     = "${var.external_database_opsman_sql_db_username}"
  password = "${var.external_database_opsman_sql_db_password}"
  instance = "${google_sql_database_instance.master.name}"
  host     = "${var.external_database_opsman_sql_db_host}"

  depends_on = ["google_sql_user.root"]

  count = "${var.count}"
}

resource "google_sql_database" "opsman" {
  name       = "${var.env_name}"
  instance   = "${google_sql_database_instance.master.name}"
  depends_on = ["google_sql_user.opsman-user"]

  count = "${var.count}"
}
