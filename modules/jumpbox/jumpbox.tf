locals {
  create_jumpbox = "${length(var.jumpbox_init_script) > 0 ? 1 : 0}"
}

resource "google_compute_firewall" "jumpbox-external" {
  count = "${local.create_jumpbox}"

  name    = "${var.env_name}-jumpbox-external"
  network = "${var.pcf_network}"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = ["${var.env_name}-jumpbox-external"]
}

data "template_file" "jumpbox_init_script" {
  count = "${local.create_jumpbox}"

  template = "${file(var.jumpbox_init_script)}"

  vars {
    env_name = "${var.env_name}"
  }
}

resource "google_compute_instance" "jumpbox" {
  count = "${local.create_jumpbox}"

  name         = "${var.env_name}-jumpbox"
  machine_type = "n1-standard-2"
  zone         = "${var.availability_zone}"

  tags = ["${var.env_name}", "${var.env_name}-jumpbox-external"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1604-lts"
      size  = "100"
    }
  }

  // Local SSD disk
  scratch_disk {}

  network_interface {
    subnetwork = "${var.subnet}"

    access_config {
      // Ephemeral IP
    }
  }

  metadata {
    environment = "${var.env_name}"
    sshKeys     = "${var.jumpbox_public_key}"
  }

  provisioner "file" {
    content     = "${data.template_file.jumpbox_init_script.rendered}"
    destination = "/tmp/jumpbox_init.sh"

    connection {
      type        = "ssh"
      user        = "${var.username}"
      private_key = "${var.jumpbox_private_key}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/jumpbox_init.sh",
      "/tmp/jumpbox_init.sh",
    ]

    connection {
      type        = "ssh"
      user        = "${var.username}"
      private_key = "${var.jumpbox_private_key}"
      agent       = false
    }
  }

  service_account {
    scopes = ["compute-ro", "storage-ro"]
  }
}
