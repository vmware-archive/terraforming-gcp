variable "project" {
  type = "string"
}

variable "env_name" {
  default = ""
}

variable "region" {
  type = "string"
}

variable "internetless" {}

variable "infrastructure_cidr" {
  type = "string"
}

variable "dns_suffix" {
  type = "string"
}

variable "create_blobstore_service_account_key" {
  default = false
}

variable "internal_access_source_ranges" {
  type    = "list"
  default = []
}
