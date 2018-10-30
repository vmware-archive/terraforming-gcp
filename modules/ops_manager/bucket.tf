resource "google_storage_bucket" "director" {
  name          = "${var.project}-${var.env_name}-director"
  force_destroy = true

  count = "${var.opsman_storage_bucket_count}"
}
