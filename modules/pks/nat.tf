resource "google_compute_address" "nat-address" {
  name   = "${var.env_name}-cloud-nat"
  region = "${var.region}"
}

resource "google_compute_router" "nat-router" {
  name    = "${var.env_name}-nat-router"
  region  = "${var.region}"
  network = "${var.network_name}"

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat" {
  name                               = "${var.env_name}-cloud-nat"
  router                             = "${google_compute_router.nat-router.name}"
  region                             = "${var.region}"
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = ["${google_compute_address.nat-address.self_link}"]
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name = "${google_compute_subnetwork.pks-subnet.self_link}"
  }

  subnetwork {
    name = "${google_compute_subnetwork.pks-services-subnet.self_link}"
  }
}
