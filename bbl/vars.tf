variable "project_id" {
	type = "string"
}

variable "region" {
	type = "string"
}

variable "zone" {
	type = "string"
}

variable "env_id" {
	type = "string"
}

variable "service_account_key" {
	type = "string"
}

variable "count" {}

/* variable "cf_lb" { */
/*   default = false */
/* } */

/* variable "concourse_lb" { */
/*   default = false */
/* } */

provider "google" {
	credentials = "${var.service_account_key}"
	project = "${var.project_id}"
	region = "${var.region}"
}
