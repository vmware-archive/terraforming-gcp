module "api" {
  source   = "../load_balancer"
  env_name = "${var.env_name}"
  name     = "api"

  global  = false
  count   = 1
  network = "${var.network_name}"

  ports                 = ["9021", "8443"]
  lb_name               = "${var.env_name}-pks-api"
  forwarding_rule_ports = ["9021", "8443"]
  health_check          = false
}
