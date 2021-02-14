locals {
  count_regional = "${(!var.global && var.count > 0 ) ? 1 : 0}"
}
resource "google_compute_address" "lb" {
  name = "${var.name}-address"

  count = "${local.count_regional}"
}

resource "google_compute_forwarding_rule" "lb" {
  name        = "${var.name}-lb-${count.index}"
  ip_address  = "${google_compute_address.lb.address}"
  target      = "${google_compute_target_pool.lb.self_link}"
  port_range  = "${element(var.forwarding_rule_ports, count.index)}"
  ip_protocol = "TCP"

  count = "${local.count_regional > 0 ? length(var.forwarding_rule_ports) : 0}"
}

resource "google_compute_target_pool" "lb" {
  name = "${var.lb_name}"

  health_checks = ["${google_compute_http_health_check.lb.*.name}"]

  count = "${local.count_regional}"
}
