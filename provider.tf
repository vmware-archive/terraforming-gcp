provider "google" {
  version     = "0.1.3"

  project     = "${var.project}"
  region      = "${var.region}"
  credentials = "${var.service_account_key}"
}
