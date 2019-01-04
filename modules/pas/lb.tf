module "ssh-lb" {
  source = "../load_balancer"

  env_name = "${var.env_name}"
  name     = "ssh"

  global  = false
  count   = 1
  network = "${var.network}"

  ports                 = ["2222"]
  target_tags           = ["${var.env_name}-cf-ssh"]
  forwarding_rule_ports = ["2222"]

  health_check = false
}

module "gorouter" {
  source = "../load_balancer"

  env_name = "${var.env_name}"
  name     = "gorouter"

  global          = "${var.global_lb}"
  count           = "${var.global_lb > 0 ? 0 : 1}"
  network         = "${var.network}"
  zones           = "${var.zones}"
  ssl_certificate = "${var.ssl_certificate}"

  ports = ["80", "443"]

  target_tags = [
    "${var.env_name}-${var.global_lb > 0 ? "httpslb" : "tcplb"}",
    "${var.env_name}-isoseglb",
  ]

  forwarding_rule_ports = ["80", "443"]

  health_check                     = true
  health_check_port                = "8080"
  health_check_interval            = 5
  health_check_timeout             = 3
  health_check_healthy_threshold   = 6
  health_check_unhealthy_threshold = 3
}

module "websocket" {
  source = "../load_balancer"

  env_name = "${var.env_name}"
  name     = "websocket"

  global  = false
  network = "${var.network}"
  count   = "${var.global_lb}"

  ports                 = ["80", "443"]
  target_tags           = ["${var.env_name}-cf-ws"]
  forwarding_rule_ports = ["80", "443"]

  health_check                     = true
  health_check_port                = "8080"
  health_check_interval            = 5
  health_check_timeout             = 3
  health_check_healthy_threshold   = 6
  health_check_unhealthy_threshold = 3
}

module "tcprouter" {
  source = "../load_balancer"

  env_name = "${var.env_name}"
  name     = "tcprouter"

  global  = false
  network = "${var.network}"
  count   = 1

  ports                 = ["1024-65535"]
  target_tags           = ["${var.env_name}-cf-tcp"]
  forwarding_rule_ports = ["1024-1123"]

  health_check                     = true
  health_check_port                = "80"
  health_check_interval            = 30
  health_check_timeout             = 5
  health_check_healthy_threshold   = 10
  health_check_unhealthy_threshold = 2
}
