variable "count" {}

variable "with_firewalls" {}

variable "zones" {
  type = "list"
}

variable "env_name" {}

variable "dns_zone_dns_name" {}

variable "dns_zone_name" {}

variable "public_health_check_link" {}

variable "infrastructure_subnet_cidr" {}

variable "pas_subnet_cidr" {}

variable "network" {}

variable "internetless" {}

variable "ssl_certificate" {}

variable "replicated_suffix" {}
