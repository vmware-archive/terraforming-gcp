provider "google" {
  project     = "${var.project}"
  region      = "${var.region}"
  credentials = "${var.service_account_key}"

  version = ">= 1.7.0"
}
