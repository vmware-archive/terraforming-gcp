resource "random_id" "password" {
  byte_length = 32
}

resource "random_id" "db-name" {
  byte_length = 8
}

resource "google_sql_user" "root" {
  name     = "root"
  password = "${random_id.password.b64}"
  instance = "${google_sql_database_instance.master.name}"
  host     = "%"

  count = "${coalesce(
                        replace(replace(var.opsman_sql_instance_count, "/^0$/", ""), "/.+/", "1"),
                        replace(replace(var.ert_sql_instance_count, "/^0$/", ""), "/.+/", "1"),
                        "0"
                      )}"
}

resource "google_sql_database_instance" "master" {
  region           = "${var.region}"
  database_version = "MYSQL_5_6"
  name             = "${var.env_name}-${lower(random_id.db-name.b64)}"

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
