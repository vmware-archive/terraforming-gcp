resource "google_compute_image" "ops-manager-image" {
  name = "${var.env_name}-ops-manager-image"
  count = "${var.opsman_image_url == "" ? 0 : 1}"

  timeouts {
    create = "20m"
  }

  source_image = "projects/pivotal-ops-manager-images/global/images/ops-manager-2-10-build-48"
}

resource "google_compute_image" "optional-ops-manager-image" {
  name  = "${var.env_name}-optional-ops-manager-image"
  count = "${var.optional_opsman_image_url == "" ? 0 : 1}"

  timeouts {
    create = "20m"
  }

  source_image = "projects/pivotal-ops-manager-images/global/images/ops-manager-2-10-build-48"
}
