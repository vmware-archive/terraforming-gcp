variable "env_name" {
  default = ""
}

variable "network" {
  type = "string"
}

variable "internetless" {}

variable "egress_target_account" {
  type = "string"
}

variable "internal_cidr_ranges" {
  type    = "list"
  default = []
}
