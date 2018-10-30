output "load_balancer_name" {
  value = "${element(concat(google_compute_backend_service.isoseg_lb_backend_service.*.name, list("")), 0)}"
}

output "domain" {
  value = "${replace(replace(element(concat(google_dns_record_set.wildcard-iso-dns.*.name, list("")), 0), "/^\\*\\./", ""), "/\\.$/", "")}"
}

output "haproxy_static_ip" {
  value = "${local.haproxy_static_ip}"
}
