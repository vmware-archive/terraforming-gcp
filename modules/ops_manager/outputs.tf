output "ops_manager_public_ip" {
  value = "${google_compute_address.ops-manager-ip.address}"
}

output "ops_manager_ip" {
  value = "${google_compute_address.ops-manager-ip.address}"
}

output "ops_manager_private_ip" {
  value = "${google_compute_instance.ops-manager.network_interface.0.address}"
}

output "optional_ops_manager_public_ip" {
  value = "${element(concat(google_compute_address.optional-ops-manager-ip.*.address, list("")), 0)}"
}

output "ops_manager_ssh_private_key" {
  sensitive = true
  value     = "${tls_private_key.ops-manager.private_key_pem}"
}

output "ops_manager_ssh_public_key" {
  sensitive = true
  value     = "${format("ubuntu:%s", tls_private_key.ops-manager.public_key_openssh)}"
}

output "director_blobstore_bucket" {
  value = "${element(concat(google_storage_bucket.director.*.name, list("")), 0)}"
}

output "ops_manager_dns" {
  value = "${replace(google_dns_record_set.ops-manager-dns.name, "/\\.$/", "")}"
}

output "optional_ops_manager_dns" {
  value = "${replace(element(concat(google_dns_record_set.optional-ops-manager-dns.*.name, list("")), 0), "/\\.$/", "")}"
}

output "service_account_email" {
  value = "${google_service_account.opsman_service_account.email}"
}

output "sql_db_name" {
  value = "${element(concat(google_sql_database.opsman.*.name, list("")), 0)}"
}

output "sql_username" {
  value = "${element(concat(random_id.opsman_db_username.*.b64, list("")), 0)}"
}

output "sql_password" {
  sensitive = true
  value     = "${element(concat(random_id.opsman_db_password.*.b64, list("")), 0)}"
}
