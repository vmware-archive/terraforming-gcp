resource "google_compute_instance_group" "isoseglb" {
  // Count based on number of AZs
  count       = "${var.count == "1" ? 3 : 0}"
  name        = "${var.env_name}-isoseglb-${element(var.zones, count.index)}"
  description = "terraform generated instance group that is multi-zone for isolation segment load-balancing"
  zone        = "${element(var.zones, count.index)}"
}
