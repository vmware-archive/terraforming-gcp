module "plane-lb" {
  source = "../load_balancer"

  env_name = "${var.env_name}"
  name     = "plane"

  global  = false
  count   = 1
  network = "${var.network}"

  ports                 = ["2222", "443", "8443"]
  target_tags           = ["${var.env_name}-control-plane"]
  forwarding_rule_ports = ["2222", "443", "8443"]

  health_check = false
}
