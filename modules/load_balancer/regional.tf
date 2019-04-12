locals {
  forwarding_rule_ports = "${split(":", local.discrete_lbs ? join(":", keys(var.ports_lb_map)) : join(":", var.forwarding_rule_ports))}"
}

resource "google_compute_address" "lb" {
  name = "${var.env_name}-${var.name}-address"

  count = "${var.count}"
}

resource "google_compute_forwarding_rule" "lb" {
  name        = "${var.env_name}-${var.name}-lb-${count.index}"
  ip_address  = "${google_compute_address.lb.address}"
  target      = "${google_compute_target_pool.lb.self_link}"
  port_range  = "${element(local.forwarding_rule_ports, count.index)}"
  ip_protocol = "TCP"

  count = "${var.count > 0 ? length(local.forwarding_rule_ports) : 0}"
}

resource "google_compute_target_pool" "lb" {
  name = "${element(local.lb_names, count.index)}"

  health_checks = ["${google_compute_http_health_check.lb.*.name}"]

  count = "${var.count > 0 ? length(local.lb_names) : 0}"
}
