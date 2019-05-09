variable "env_name" {
  type = "string"
}

variable "network" {
  type = "string"
}

variable "zones" {
  type = "list"
}

variable "region" {
  type = "string"
}

variable "project" {
  type = "string"
}

variable "dns_zone_dns_name" {
  type = "string"
}

variable "dns_zone_name" {
  type = "string"
}

variable "control_plane_cidr" {
  type = "string"
}

variable "lb_cert_pem" {
  type = "string"
}

variable "lb_private_key_pem" {
  type = "string"
}
