module "ssh-lb" {
  source = "../load_balancer"

  env_name = "${var.env_name}"
  name     = "${var.env_name}-ssh"

  global  = false
  count   = 1
  network = "${var.network}"

  ports                 = ["2222"]
  forwarding_rule_ports = ["2222"]
  lb_name               = "${var.env_name}-cf-ssh"

  health_check = false
}

module "gorouter" {
  source = "../load_balancer"

  env_name = "${var.env_name}"
  name     = "${var.env_name}-gorouter"

  global                     = "${var.global_lb}"
  url_map_name               = "${var.env_name}-cf-http"
  http_proxy_name            = "${var.env_name}-httpproxy"
  https_proxy_name           = "${var.env_name}-httpsproxy"
  http_forwarding_rule_name  = "${var.env_name}-cf-lb-http"
  https_forwarding_rule_name = "${var.env_name}-cf-lb-https"

  count           = "1"
  network         = "${var.network}"
  zones           = "${var.zones}"
  ssl_certificate = "${var.ssl_certificate}"

  ports = ["80", "443"]

  optional_target_tag   = "${var.isoseg_lb_name}"
  lb_name               = "${var.env_name}-${var.global_lb > 0 ? "httpslb" : "tcplb"}"
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
  name     = "${var.env_name}-websocket"

  global  = false
  network = "${var.network}"
  count   = "${var.global_lb ? 1 : 0}"

  ports                 = ["80", "443"]
  lb_name               = "${var.env_name}-cf-ws"
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
  name     = "${var.env_name}-tcprouter"

  global  = false
  network = "${var.network}"
  count   = "${var.create_tcp_router ? 1 : 0}"

  ports                 = ["1024-65535"]
  lb_name               = "${var.env_name}-cf-tcp"
  forwarding_rule_ports = ["1024-1123"]

  health_check                     = true
  health_check_port                = "80"
  health_check_interval            = 30
  health_check_timeout             = 5
  health_check_healthy_threshold   = 10
  health_check_unhealthy_threshold = 2
}
