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

resource "google_compute_instance" "ops-manager" {
  name         = "${var.env_name}-ops-manager"
  depends_on   = ["google_compute_subnetwork.ops-manager-subnet"]
  machine_type = "n1-standard-2"
  zone         = "${element(var.zones, 1)}"

  tags = ["${var.env_name}-ops-manager-external"]

  disk {
    image = "${var.opsman_image_name}"
    size  = 50
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.ops-manager-subnet.name}"

    access_config {
      # Empty for ephemeral external IP allocation
    }
  }
}

resource "google_sql_database_instance" "master" {
  region = "${var.sql_region}"

  settings {
    tier = "${var.google_sql_db_tier}"

    ip_configuration = {
      ipv4_enabled = true

      authorized_networks = [
        {
          name  = "all"
          value = "0.0.0.0/0"
        },
      ]
    }
  }

  count = "${var.google_sql_instance_count}"
}

resource "google_sql_database" "users" {
  name     = "${var.env_name}-db"
  instance = "${google_sql_database_instance.master.name}"

  count = "${var.google_sql_instance_count}"
}

resource "google_sql_user" "users" {
  name     = "${var.google_sql_db_username}"
  password = "${var.google_sql_db_password}"
  instance = "${google_sql_database_instance.master.name}"
  host     = "${var.google_sql_db_host}"

  count = "${var.google_sql_instance_count}"
}

resource "google_storage_bucket" "director" {
  name          = "${var.env_name}-director"
  force_destroy = true

  count = "${var.opsman_storage_bucket_count}"
}
