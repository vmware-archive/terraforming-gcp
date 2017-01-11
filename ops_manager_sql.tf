resource "google_sql_user" "opsman-user" {
  name     = "${var.opsman_sql_db_username}"
  password = "${var.opsman_sql_db_password}"
  instance = "${google_sql_database_instance.master.name}"
  host     = "${var.opsman_sql_db_host}"

  count = "${var.opsman_sql_instance_count}"
}

resource "google_sql_database" "opsman" {
  name     = "${var.env_name}"
  instance = "${google_sql_database_instance.master.name}"

  count = "${var.opsman_sql_instance_count}"
}
