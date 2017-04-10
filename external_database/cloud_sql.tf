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

  count = "${var.count}"
}

resource "google_sql_database_instance" "master" {
  region           = "${var.region}"
  database_version = "MYSQL_5_6"
  name             = "${var.env_name}-${replace(lower(random_id.db-name.b64), "_", "-")}"

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

  count = "${var.count}"
}
