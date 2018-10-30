locals {
  should_create_certificate = "${length(var.ssl_cert) > 0 ? 1 :
    length(tls_locally_signed_cert.ssl_cert.*.cert_pem) > 0 ? 1 : 0}"
}

resource "tls_private_key" "ssl_private_key" {
  algorithm = "RSA"
  rsa_bits  = "2048"

  count = "${length(var.ssl_ca_cert) > 0 ? 1 : 0}"
}

resource "tls_cert_request" "ssl_csr" {
  key_algorithm   = "RSA"
  private_key_pem = "${tls_private_key.ssl_private_key.private_key_pem}"

  dns_names = "${formatlist("%s.${var.env_name}.${var.dns_suffix}", var.subdomains)}"

  count = "${length(var.ssl_ca_cert) > 0 ? 1 : 0}"

  subject {
    common_name         = "${var.env_name}.${var.dns_suffix}"
    organization        = "Pivotal"
    organizational_unit = "Cloudfoundry"
    country             = "US"
    province            = "CA"
    locality            = "San Francisco"
  }
}

resource "tls_locally_signed_cert" "ssl_cert" {
  cert_request_pem   = "${tls_cert_request.ssl_csr.cert_request_pem}"
  ca_key_algorithm   = "RSA"
  ca_private_key_pem = "${var.ssl_ca_private_key}"
  ca_cert_pem        = "${var.ssl_ca_cert}"

  count = "${length(var.ssl_ca_cert) > 0 ? 1 : 0}"

  validity_period_hours = 8760 # 1year

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "google_compute_ssl_certificate" "certificate" {
  count = "${local.should_create_certificate}"

  name_prefix = "${var.env_name}-${var.resource_name}"
  description = "user provided ssl private key / ssl certificate pair"
  certificate = "${length(var.ssl_ca_cert) > 0 ? element(concat(tls_locally_signed_cert.ssl_cert.*.cert_pem, list("")), 0) : var.ssl_cert}"
  private_key = "${length(var.ssl_ca_cert) > 0 ? element(concat(tls_private_key.ssl_private_key.*.private_key_pem, list("")), 0) : var.ssl_private_key}"

  lifecycle = {
    create_before_destroy = true
  }
}
