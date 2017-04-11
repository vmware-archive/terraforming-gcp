resource "random_id" "opsman_db_username" {
  byte_length = 8
}

resource "random_id" "opsman_db_password" {
  byte_length = 32
}

resource "random_id" "ert_db_username" {
  byte_length = 8
}

resource "random_id" "ert_db_password" {
  byte_length = 32
}

resource "google_sql_user" "ert" {
  name     = "${random_id.ert_db_username.b64}"
  password = "${random_id.ert_db_password.b64}"
  instance = "${google_sql_database_instance.master.name}"
  host     = "${var.ert_sql_db_host}"

  count = "${var.count}"
}

resource "google_sql_user" "opsman" {
  name       = "${random_id.opsman_db_username.b64}"
  password   = "${random_id.opsman_db_password.b64}"
  instance   = "${google_sql_database_instance.master.name}"
  host       = "${var.opsman_sql_db_host}"
  depends_on = ["google_sql_user.ert"]

  count = "${var.count}"
}
