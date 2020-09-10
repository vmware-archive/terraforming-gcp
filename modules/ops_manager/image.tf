# resource "google_compute_image" "ops-manager-image" {
#   name = "${var.env_name}-ops-manager-image"
#   count = "${var.opsman_image_url == "" ? 0 : 1}"

#   timeouts {
#     create = "20m"
#   }

#   raw_disk {
#     source = "${var.optional_opsman_image_url}"
#   }
# }

# resource "google_compute_image" "optional-ops-manager-image" {
#   name  = "${var.env_name}-optional-ops-manager-image"
#   count = "${var.optional_opsman_image_url == "" ? 0 : 1}"

#   timeouts {
#     create = "20m"
#   }

#   raw_disk {
#     source = "${var.optional_opsman_image_url}"
#   }
# }
