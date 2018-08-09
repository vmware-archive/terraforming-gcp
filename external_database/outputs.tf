output "opsman_sql_db_name" {
  value = "${element(concat(google_sql_database.opsman.*.name, list("")), 0)}"
}

output "opsman_sql_username" {
  value = "${element(concat(random_id.opsman_db_username.*.b64, list("")), 0)}"
}

output "opsman_sql_password" {
  sensitive = true
  value     = "${element(concat(random_id.opsman_db_password.*.b64, list("")), 0)}"
}

output "pas_sql_username" {
  value = "${element(concat(random_id.pas_db_username.*.b64, list("")), 0)}"
}

output "pas_sql_password" {
  sensitive = true
  value     = "${element(concat(random_id.pas_db_password.*.b64, list("")), 0)}"
}

output "pas_sql_cert" {
  sensitive = true
  value     = "${element(concat(google_sql_database_instance.master.*.server_ca_cert.0.cert, list("")), 0)}"
}

output "ip" {
  value = "${element(concat(google_sql_database_instance.master.*.first_ip_address, list("")), 0)}"
}
