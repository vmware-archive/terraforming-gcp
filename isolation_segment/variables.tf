variable "count" {}

variable "zones" {
  type = "list"
}

variable "env_name" {}

variable "ssl_cert" {}

variable "ssl_private_key" {}

variable "dns_zone_dns_name" {}

variable "dns_zone_name" {}

variable "public_healthcheck_link" {}
