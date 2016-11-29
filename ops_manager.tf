# Allow HTTP/S access to Ops Manager from the outside world
resource "google_compute_firewall" "ops-manager-external" {
  name       = "${var.env_name}-ops-manager-external"
  depends_on = ["google_compute_network.pcf-network"]
  network    = "${google_compute_network.pcf-network.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }

  target_tags = ["${var.env_name}-ops-manager-external"]
}

resource "google_compute_image" "ops-manager-image" {
  name = "${var.env_name}-ops-manager-image"

  raw_disk {
    source = "${var.opsman_image_url}"
  }

  create_timeout = 10
}

resource "google_compute_instance" "ops-manager" {
  name         = "${var.env_name}-ops-manager"
  depends_on   = ["google_compute_subnetwork.ops-manager-subnet"]
  machine_type = "n1-standard-2"
  zone         = "${element(var.zones, 1)}"

  tags = ["${var.env_name}-ops-manager-external"]

  disk {
    image = "${google_compute_image.ops-manager-image.self_link}"
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.ops-manager-subnet.name}"

    access_config {
      # Empty for ephemeral external IP allocation
    }
  }
}

resource "google_storage_bucket" "director" {
  name          = "${var.env_name}-director"
  force_destroy = true

  count = "${var.opsman_storage_bucket_count}"
}
