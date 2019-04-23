resource "google_compute_managed_ssl_certificate" "credhub_managed_cert" {
  name = "${var.env_name}-credhub-managed-cert"

  managed {
    domains = ["credhub.${var.dns_zone_dns_name}"]
  }
}

resource "google_compute_managed_ssl_certificate" "uaa_managed_cert" {
  name = "${var.env_name}-uaa-managed-cert"

  managed {
    domains = ["uaa.${var.dns_zone_dns_name}"]
  }
}
