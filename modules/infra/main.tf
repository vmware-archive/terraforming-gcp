resource "google_compute_network" "pcf" {
  name                    = "${var.env_name}-pcf-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "infrastructure" {
  name                     = "${var.env_name}-infrastructure-subnet"
  ip_cidr_range            = "${var.infrastructure_cidr}"
  network                  = "${google_compute_network.pcf.self_link}"
  region                   = "${var.region}"
  private_ip_google_access = "${var.internetless}"
}

resource "google_dns_managed_zone" "default" {
  name        = "${var.env_name}-zone"
  dns_name    = "${var.env_name}.${var.dns_suffix}."
  description = "DNS zone for the ${var.env_name} environment"
}

resource "google_service_account" "blobstore_service_account" {
  count = "${var.create_blobstore_service_account_key}"

  account_id   = "${var.env_name}-blobstore"
  display_name = "${var.env_name} Blobstore Service Account"
}

resource "google_service_account_key" "blobstore_service_account_key" {
  count = "${var.create_blobstore_service_account_key}"

  service_account_id = "${google_service_account.blobstore_service_account.id}"
}

resource "google_project_iam_member" "blobstore_cloud_storage_admin" {
  count = "${var.create_blobstore_service_account_key}"

  project = "${var.project}"
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.blobstore_service_account.email}"
}

// Allow open access between internal VMs for a PCF deployment
resource "google_compute_firewall" "pcf-internal" {
  name    = "${var.env_name}-pcf-internal"
  network = "${google_compute_network.pcf.self_link}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  source_ranges = "${concat(list(var.infrastructure_cidr), var.internal_access_source_ranges)}"
}
