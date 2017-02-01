resource "google_sql_user" "ert" {
  name     = "${var.ert_sql_db_username}"
  password = "${var.ert_sql_db_password}"
  instance = "${google_sql_database_instance.master.name}"
  host     = "${var.ert_sql_db_host}"

  depends_on = ["google_sql_user.root"]

  count = "${var.ert_sql_instance_count}"
}

resource "google_sql_database" "uaa" {
  name       = "uaa"
  instance   = "${google_sql_database_instance.master.name}"
  depends_on = ["google_sql_user.ert"]

  count = "${var.ert_sql_instance_count}"
}

resource "google_sql_database" "ccdb" {
  name       = "ccdb"
  instance   = "${google_sql_database_instance.master.name}"
  depends_on = ["google_sql_database.uaa"]

  count = "${var.ert_sql_instance_count}"
}

resource "google_sql_database" "notifications" {
  name       = "notifications"
  instance   = "${google_sql_database_instance.master.name}"
  depends_on = ["google_sql_database.ccdb"]

  count = "${var.ert_sql_instance_count}"
}

resource "google_sql_database" "autoscale" {
  name       = "autoscale"
  instance   = "${google_sql_database_instance.master.name}"
  depends_on = ["google_sql_database.notifications"]

  count = "${var.ert_sql_instance_count}"
}

resource "google_sql_database" "app_usage_service" {
  name       = "app_usage_service"
  instance   = "${google_sql_database_instance.master.name}"
  depends_on = ["google_sql_database.autoscale"]

  count = "${var.ert_sql_instance_count}"
}

resource "google_sql_database" "console" {
  name       = "console"
  instance   = "${google_sql_database_instance.master.name}"
  depends_on = ["google_sql_database.app_usage_service"]

  count = "${var.ert_sql_instance_count}"
}

resource "google_sql_database" "diego" {
  name       = "diego"
  instance   = "${google_sql_database_instance.master.name}"
  depends_on = ["google_sql_database.console"]

  count = "${var.ert_sql_instance_count}"
}

resource "google_sql_database" "routing" {
  name       = "routing"
  instance   = "${google_sql_database_instance.master.name}"
  depends_on = ["google_sql_database.diego"]

  count = "${var.ert_sql_instance_count}"
}
