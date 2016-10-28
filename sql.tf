resource "google_sql_database_instance" "master" {
  region = "${var.region}"
  database_version = "MYSQL_5_6"

  settings {
    tier = "${var.sql_db_tier}"

    ip_configuration = {
      ipv4_enabled = true

      authorized_networks = [
        {
          name  = "all"
          value = "0.0.0.0/0"
        },
      ]
    }
  }

  // If any database is necessary, create a database instance. Otherwise, do not create a database instance.
  count = "${coalesce(
    replace(replace(var.opsman_sql_instance_count, "/^0$/", ""), "/.+/", "1"),
    replace(replace(var.ert_sql_instance_count, "/^0$/", ""), "/.+/", "1"),
    "0"
  )}"
}
