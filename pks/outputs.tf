output "load_balancer_name" {
  value = "${element(concat(google_compute_target_pool.pks-api.*.name, list("")), 0)}"
}

output "domain" {
  value = "${replace(replace(element(concat(google_dns_record_set.wildcard-pks-dns.*.name, list("")), 0), "/^\\*\\./", ""), "/\\.$/", "")}"
}
