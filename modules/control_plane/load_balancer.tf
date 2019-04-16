module "plane-lb" {
  source = "../load_balancer"

  env_name = "${var.env_name}"
  name     = "plane"

  global  = false
  count   = 1
  network = "${var.network}"

  ports_lb_map = {
    "2222,443" = "${var.env_name}-control-plane"
    "8443"     = "${var.env_name}-uaa-control-plane"
    "8844"     = "${var.env_name}-credhub-control-plane"
  }

  health_check = false
}
