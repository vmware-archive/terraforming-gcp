resource "google_sql_database" "opsman" {
  name       = "${var.env_name}"
  instance   = "${google_sql_database_instance.master.name}"
  depends_on = ["google_sql_database.nfsvolume"]
}
