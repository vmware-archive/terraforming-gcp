resource "google_compute_url_map" "isoseg_lb_url_map" {
  name            = "${var.env_name}-isoseg"
  default_service = "${google_compute_backend_service.isoseg_lb_backend_service.self_link}"

  count = "${var.count}"
}

resource "google_compute_target_http_proxy" "isoseg_http_lb_proxy" {
  name        = "${var.env_name}-isoseg-http-proxy"
  description = "really a load balancer but listed as an http proxy"
  url_map     = "${google_compute_url_map.isoseg_lb_url_map.self_link}"

  count = "${var.count}"
}

resource "google_compute_target_https_proxy" "isoseg_https_lb_proxy" {
  name             = "${var.env_name}-isoseg-https-proxy"
  description      = "really a load balancer but listed as an https proxy"
  url_map          = "${google_compute_url_map.isoseg_lb_url_map.self_link}"
  ssl_certificates = ["${google_compute_ssl_certificate.isoseg_cert.self_link}"]

  count = "${var.count}"
}

resource "google_compute_ssl_certificate" "isoseg_cert" {
  name_prefix = "${var.env_name}-isoseg-lbcert"
  description = "user provided ssl private key / ssl certificate pair"
  private_key = "${var.iso_seg_ssl_private_key}"
  certificate = "${var.iso_seg_ssl_cert}"

  lifecycle = {
    create_before_destroy = true
  }

  count = "${var.count}"
}
