variable "project" {}
variable "env_name" {}

variable "zones" {
  type = "list"
}

variable "opsman_machine_type" {}
variable "opsman_storage_bucket_count" {}
variable "opsman_image_url" {}

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

variable "sql_instance" {
  default = ""
}

variable "opsman_sql_db_host" {
  default = ""
}
