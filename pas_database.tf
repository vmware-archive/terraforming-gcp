resource "google_sql_database" "uaa" {
  name       = "uaa"
  instance   = "${google_sql_database_instance.master.name}"
  depends_on = ["google_sql_user.pas", "google_sql_user.opsman"]
}

resource "google_sql_database" "ccdb" {
  name       = "ccdb"
  instance   = "${google_sql_database_instance.master.name}"
  depends_on = ["google_sql_database.uaa"]
}

resource "google_sql_database" "notifications" {
  name       = "notifications"
  instance   = "${google_sql_database_instance.master.name}"
  depends_on = ["google_sql_database.ccdb"]
}

resource "google_sql_database" "autoscale" {
  name       = "autoscale"
  instance   = "${google_sql_database_instance.master.name}"
  depends_on = ["google_sql_database.notifications"]
}

resource "google_sql_database" "app_usage_service" {
  name       = "app_usage_service"
  instance   = "${google_sql_database_instance.master.name}"
  depends_on = ["google_sql_database.autoscale"]
}

resource "google_sql_database" "console" {
  name       = "console"
  instance   = "${google_sql_database_instance.master.name}"
  depends_on = ["google_sql_database.app_usage_service"]
}

resource "google_sql_database" "diego" {
  name       = "diego"
  instance   = "${google_sql_database_instance.master.name}"
  depends_on = ["google_sql_database.console"]
}

resource "google_sql_database" "routing" {
  name       = "routing"
  instance   = "${google_sql_database_instance.master.name}"
  depends_on = ["google_sql_database.diego"]
}

resource "google_sql_database" "account" {
  name       = "account"
  instance   = "${google_sql_database_instance.master.name}"
  depends_on = ["google_sql_database.routing"]
}

resource "google_sql_database" "networkpolicyserver" {
  name       = "networkpolicyserver"
  instance   = "${google_sql_database_instance.master.name}"
  depends_on = ["google_sql_database.account"]
}

resource "google_sql_database" "nfsvolume" {
  name       = "nfsvolume"
  instance   = "${google_sql_database_instance.master.name}"
  depends_on = ["google_sql_database.networkpolicyserver"]
}

resource "google_sql_database" "silk" {
  name       = "silk"
  instance   = "${google_sql_database_instance.master.name}"
  depends_on = ["google_sql_database.nfsvolume"]
}

resource "google_sql_database" "locket" {
  name       = "locket"
  instance   = "${google_sql_database_instance.master.name}"
  depends_on = ["google_sql_database.silk"]
}

resource "google_sql_database" "credhub" {
  name       = "credhub"
  instance   = "${google_sql_database_instance.master.name}"
  depends_on = ["google_sql_database.locket"]
}
