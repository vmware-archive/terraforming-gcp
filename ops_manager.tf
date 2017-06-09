# Allow HTTP/S access to Ops Manager from the outside world
resource "google_compute_firewall" "ops-manager-external" {
  name        = "${var.env_name}-ops-manager-external"
  network     = "${google_compute_network.pcf-network.name}"
  target_tags = ["${var.env_name}-ops-manager-external"]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }
}

resource "google_compute_image" "ops-manager-image" {
  name           = "${var.env_name}-ops-manager-image"
  create_timeout = 20

  raw_disk {
    source = "${var.opsman_image_url}"
  }
}

resource "google_compute_image" "optional-ops-manager-image" {
  name           = "${var.env_name}-optional-ops-manager-image"
  count          = "${min(length(split("", var.optional_opsman_image_url)),1)}"
  create_timeout = 20

  raw_disk {
    source = "${var.optional_opsman_image_url}"
  }
}

resource "google_compute_instance" "ops-manager" {
  name           = "${var.env_name}-ops-manager"
  machine_type   = "${var.opsman_machine_type}"
  zone           = "${element(var.zones, 1)}"
  create_timeout = 10
  tags           = ["${var.env_name}-ops-manager-external"]

  disk {
    image = "${google_compute_image.ops-manager-image.self_link}"
    size  = 50
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.management-subnet.name}"

    access_config {
      # Empty for ephemeral external IP allocation
    }
  }

  service_account {
    email  = "${google_service_account.opsman_service_account.email}"
    scopes = ["cloud-platform"]
  }

  metadata = {
    ssh-keys               = "${format("ubuntu:%s", tls_private_key.ops-manager.public_key_openssh)}"
    block-project-ssh-keys = "TRUE"
  }
}

resource "google_compute_instance" "optional-ops-manager" {
  name           = "${var.env_name}-optional-ops-manager"
  machine_type   = "${var.opsman_machine_type}"
  zone           = "${element(var.zones, 1)}"
  count          = "${min(length(split("", var.optional_opsman_image_url)),1)}"
  create_timeout = 10
  tags           = ["${var.env_name}-ops-manager-external"]

  disk {
    image = "${google_compute_image.optional-ops-manager-image.self_link}"
    size  = 150
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.management-subnet.name}"

    access_config {
      # Empty for ephemeral external IP allocation
    }
  }

  service_account {
    email  = "${google_service_account.opsman_service_account.email}"
    scopes = ["cloud-platform"]
  }

  metadata = {
    ssh-keys               = "${format("ubuntu:%s", tls_private_key.ops-manager.public_key_openssh)}"
    block-project-ssh-keys = "TRUE"
  }
}

resource "google_storage_bucket" "director" {
  name          = "${var.env_name}-director"
  force_destroy = true

  count = "${var.opsman_storage_bucket_count}"
}

resource "tls_private_key" "ops-manager" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}
