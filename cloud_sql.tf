resource "random_id" "db-name" {
  byte_length = 8
}

resource "google_sql_database_instance" "master" {
  region           = "${var.region}"
  database_version = "MYSQL_5_6"
  name             = "${var.env_name}-${replace(lower(random_id.db-name.b64), "_", "-")}"

  settings {
    tier = "db-f1-micro"

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
}
