resource "google_compute_address" "nat_address" {
  name   = "${var.env_name}-atc-nat"
  region = "${var.region}"
}

resource "google_compute_router" "nat_router" {
  name    = "${var.env_name}-atc-router"
  region  = "${var.region}"
  network = "${var.network}"
}

resource "google_compute_router_nat" "nat" {
  name                               = "${var.env_name}-atc-nat"
  router                             = "${google_compute_router.nat_router.name}"
  region                             = "${var.region}"
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = ["${google_compute_address.nat_address.self_link}"]
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
    name                    = "${google_compute_subnetwork.control-plane.self_link}"
  }
}
