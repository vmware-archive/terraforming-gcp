resource "google_compute_global_forwarding_rule" "isoseg-http" {
  name       = "${var.env_name}-isoseg-lb-http"
  ip_address = "${google_compute_global_address.isoseg.address}"
  target     = "${google_compute_target_http_proxy.isoseg_http_lb_proxy.self_link}"
  port_range = "80"

  count = "${var.count}"
}

resource "google_compute_global_forwarding_rule" "isoseg-https" {
  name       = "${var.env_name}-isoseg-lb-https"
  ip_address = "${google_compute_global_address.isoseg.address}"
  target     = "${google_compute_target_https_proxy.isoseg_https_lb_proxy.self_link}"
  port_range = "443"

  count = "${var.count}"
}

resource "google_compute_global_address" "isoseg" {
  name = "${var.env_name}-isoseg"

  count = "${var.count}"
}
