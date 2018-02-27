variable "count" {}

variable "pks_cidr" {}
variable "pks_services_cidr" {}

variable "env_name" {}
variable "network_name" {}
variable "zones" {
  type = "list"
}
variable "region" {}

variable "dns_zone_dns_name" {}

variable "dns_zone_name" {}
