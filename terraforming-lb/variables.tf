variable "project" {}
variable "region" {}
variable "service_account_key" {}
variable "use_internal_lb" {
  default = "false"
}

variable "zones" {
  type = "list"
}
