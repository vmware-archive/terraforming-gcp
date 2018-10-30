variable "env_name" {
  type = "string"
}

variable "network_name" {}

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

variable "pks_cidr" {
  type = "string"
}

variable "pks_services_cidr" {
  type = "string"
}
