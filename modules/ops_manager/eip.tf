resource "google_compute_address" "ops-manager-ip" {
  name = "${var.env_name}-ops-manager-ip"
}

resource "google_compute_address" "optional-ops-manager-ip" {
  name  = "${var.env_name}-optional-ops-manager-ip"
  count = "${min(length(split("", var.optional_opsman_image_url)),1)}"
}
