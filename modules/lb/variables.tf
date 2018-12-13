variable "env_name" {
  default = ""
}

variable "region" {
  default = ""
}

variable "pas_cidr" {
  type = "string"
}

variable "services_cidr" {
  type = "string"
}

variable "network" {
  type = "string"
}

variable "internetless" {}

variable "dns_zone_dns_name" {
  type = "string"
}

variable "dns_zone_name" {
  type = "string"
}

variable "global_lb" {}

variable "zones" {
  type = "list"
}

variable "ssl_certificate" {
  type = "string"
}

variable "use_internal_lb" {}

variable "subnetwork_name" {}
