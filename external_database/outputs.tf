output "sql_db_ip" {
  value = "${google_sql_database_instance.master.ip_address.0.ip_address}"
}

output "sql_db_root_password" {
  value = "${google_sql_user.root.password}"
}

output "opsman_sql_db_name" {
  value = "${google_sql_database.opsman.name}"
}

output "ert_sql_username" {
  value = "${var.external_database_ert_sql_db_username}"
}

output "ert_sql_password" {
  value = "${var.external_database_ert_sql_db_password}"
}

output "ip" {
  value = "${google_sql_database_instance.master.ip_address.0.ip_address}"
}

output "root_password" {
  value = "${google_sql_user.root.password}"
}
