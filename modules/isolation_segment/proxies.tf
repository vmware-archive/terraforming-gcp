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
  ssl_certificates = ["${var.ssl_certificate}"]

  count = "${var.count}"
}
