resource "google_compute_ssl_certificate" "lb_managed_cert" {
  name_prefix = "${var.env_name}-lb-managed-cert"
  private_key = "${var.lb_private_key_pem}"
  certificate = "${var.lb_cert_pem}${var.lb_issuer_cert}"

  lifecycle {
    create_before_destroy = true
  }
}
