variable "project" {}
variable "env_name" {}

variable "zones" {
  type = "list"
}

variable "opsman_machine_type" {}
variable "opsman_storage_bucket_count" {}
variable "opsman_image_url" {}
variable "optional_opsman_image_url" {}
variable "pcf_network_name" {}
variable "opsman_service_account_email" {}
variable "management_subnet_name" {}
variable "dns_zone_name" {}
variable "dns_zone_dns_name" {}