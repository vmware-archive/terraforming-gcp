resource "google_compute_instance" "optional-ops-manager" {
  name         = "${var.env_name}-optional-ops-manager"
  machine_type = "${var.opsman_machine_type}"
  zone         = "${element(var.zones, 1)}"
  count        = "${min(length(split("", var.optional_opsman_image_url)),1)}"
  tags         = ["${var.env_name}-ops-manager-external"]

  timeouts {
    create = "10m"
  }

  boot_disk {
    initialize_params {
      image = "projects/pivotal-ops-manager-images/global/images/ops-manager-2-10-build-48"
      size  = 150
    }
  }

  network_interface {
    subnetwork = "${var.subnet}"

    access_config {
      nat_ip = "${google_compute_address.optional-ops-manager-ip.address}"
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
