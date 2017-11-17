output "sql_db_ip" {
  value = "${element(concat(google_sql_database_instance.master.ip_address.*.ip_address, list("")), 0)}"
}

output "opsman_sql_db_name" {
  value = "${element(concat(google_sql_database.opsman.*.name, list("")), 0)}"
}

output "opsman_sql_username" {
  value = "${element(concat(random_id.opsman_db_username.*.b64, list("")), 0)}"
}

output "opsman_sql_password" {
  sensitive = true
  value = "${element(concat(random_id.opsman_db_password.*.b64, list("")), 0)}"
}

output "pas_sql_username" {
  value = "${element(concat(random_id.pas_db_username.*.b64, list("")), 0)}"
}

output "pas_sql_password" {
  sensitive = true
  value = "${element(concat(random_id.pas_db_password.*.b64, list("")), 0)}"
}

output "ip" {
  value = "${element(concat(google_sql_database_instance.master.*.ip_address.0.ip_address., list("")), 0)}"
}
