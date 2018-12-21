variable "project" {}
variable "env_name" {}

variable "ops_man_image_creation_timeout" {
  type    = "string"
  default = "10m"
}

variable "zones" {
  type = "list"
}

variable "opsman_machine_type" {}
variable "opsman_storage_bucket_count" {}
variable "opsman_image_url" {}

variable "vm_count" {}

variable "optional_opsman_image_url" {
  default = ""
}

variable "pcf_network_name" {}

variable "subnet" {}

variable "dns_zone_name" {
  type = "string"
}

variable "dns_zone_dns_name" {
  type = "string"
}

variable "create_iam_service_account_members" {}

variable "external_database" {
  default = false
}

variable "sql_instance" {
  default = ""
}

variable "opsman_sql_db_host" {
  default = ""
}
