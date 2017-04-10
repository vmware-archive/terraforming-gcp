resource "google_sql_user" "ert" {
  name     = "${var.external_database_ert_sql_db_username}"
  password = "${var.external_database_ert_sql_db_password}"
  instance = "${google_sql_database_instance.master.name}"
  host     = "${var.external_database_ert_sql_db_host}"

  depends_on = ["google_sql_user.root"]

  count = "${var.count}"
}

resource "google_sql_database" "uaa" {
  name       = "uaa"
  instance   = "${google_sql_database_instance.master.name}"
  depends_on = ["google_sql_user.ert"]

  count = "${var.count}"
}

resource "google_sql_database" "ccdb" {
  name       = "ccdb"
  instance   = "${google_sql_database_instance.master.name}"
  depends_on = ["google_sql_database.uaa"]

  count = "${var.count}"
}

resource "google_sql_database" "notifications" {
  name       = "notifications"
  instance   = "${google_sql_database_instance.master.name}"
  depends_on = ["google_sql_database.ccdb"]

  count = "${var.count}"
}

resource "google_sql_database" "autoscale" {
  name       = "autoscale"
  instance   = "${google_sql_database_instance.master.name}"
  depends_on = ["google_sql_database.notifications"]

  count = "${var.count}"
}

resource "google_sql_database" "app_usage_service" {
  name       = "app_usage_service"
  instance   = "${google_sql_database_instance.master.name}"
  depends_on = ["google_sql_database.autoscale"]

  count = "${var.count}"
}

resource "google_sql_database" "console" {
  name       = "console"
  instance   = "${google_sql_database_instance.master.name}"
  depends_on = ["google_sql_database.app_usage_service"]

  count = "${var.count}"
}

resource "google_sql_database" "diego" {
  name       = "diego"
  instance   = "${google_sql_database_instance.master.name}"
  depends_on = ["google_sql_database.console"]

  count = "${var.count}"
}

resource "google_sql_database" "routing" {
  name       = "routing"
  instance   = "${google_sql_database_instance.master.name}"
  depends_on = ["google_sql_database.diego"]

  count = "${var.count}"
}

resource "google_sql_database" "account" {
  name       = "account"
  instance   = "${google_sql_database_instance.master.name}"
  depends_on = ["google_sql_database.routing"]

  count = "${var.count}"
}

resource "google_sql_database" "networkpolicyserver" {
  name       = "networkpolicyserver"
  instance   = "${google_sql_database_instance.master.name}"
  depends_on = ["google_sql_database.account"]

  count = "${var.count}"
}

resource "google_sql_database" "nfsvolume" {
  name       = "nfsvolume"
  instance   = "${google_sql_database_instance.master.name}"
  depends_on = ["google_sql_database.networkpolicyserver"]

  count = "${var.count}"
}
