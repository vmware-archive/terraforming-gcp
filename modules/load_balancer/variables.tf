variable "env_name" {
  type = "string"
}

variable "name" {
  type = "string"
}

variable "global" {
  type = "string"
}

variable "network" {
  type = "string"
}

variable "health_check" {}

variable "forwarding_rule_ports" {
  type = "list"
}

variable "count" {
  default = "0"
}

variable "lb_name" {}

## OPTIONAL
variable "ports" {
  type    = "list"
  default = []
}

variable "health_check_port" {
  default = 0
}

variable "health_check_interval" {
  default = 0
}

variable "health_check_timeout" {
  default = 0
}

variable "health_check_healthy_threshold" {
  default = 0
}

variable "health_check_unhealthy_threshold" {
  default = 0
}

variable "zones" {
  type    = "list"
  default = []
}

variable "ssl_certificate" {
  type    = "string"
  default = ""
}

variable "optional_target_tag" {
  default = ""
}
