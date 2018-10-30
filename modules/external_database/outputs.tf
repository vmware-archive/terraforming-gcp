output "ip" {
  value = "${element(concat(google_sql_database_instance.master.*.first_ip_address, list("")), 0)}"
}

output "sql_instance" {
  value = "${element(concat(google_sql_database_instance.master.*.name, list("")), 0)}"
}
