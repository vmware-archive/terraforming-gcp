module "plane-lb" {
  source = "../load_balancer"

  env_name = "${var.env_name}"
  name     = "plane"

  global  = false
  count   = 1
  network = "${var.network}"

  ports                 = ["2222", "443", "8443", "8844"]
  forwarding_rule_ports = ["2222", "443", "8443", "8844"]

  lb_name      = "${var.env_name}-control-plane"
  health_check = false
}
