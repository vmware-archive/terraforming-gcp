resource "google_service_account" "pks_master_node_service_account" {
  account_id   = "${var.env_name}-pks-master"
  display_name = "${var.env_name} PKS Service Account"
}

resource "google_service_account_key" "pks_master_node_service_account_key" {
  service_account_id = "${google_service_account.pks_master_node_service_account.id}"
}

resource "google_service_account" "pks_worker_node_service_account" {
  account_id   = "${var.env_name}-pks-worker"
  display_name = "${var.env_name} PKS Service Account"
}

resource "google_service_account_key" "pks_worker_node_service_account_key" {
  service_account_id = "${google_service_account.pks_worker_node_service_account.id}"
}

resource "google_project_iam_member" "pks_master_node_compute_instance_admin" {
  project = "${var.project}"
  role    = "roles/compute.instanceAdmin"
  member  = "serviceAccount:${google_service_account.pks_master_node_service_account.email}"
}

resource "google_project_iam_member" "pks_master_node_compute_network_admin" {
  project = "${var.project}"
  role    = "roles/compute.networkAdmin"
  member  = "serviceAccount:${google_service_account.pks_master_node_service_account.email}"
}

resource "google_project_iam_member" "pks_master_node_compute_storage_admin" {
  project = "${var.project}"
  role    = "roles/compute.storageAdmin"
  member  = "serviceAccount:${google_service_account.pks_master_node_service_account.email}"
}

resource "google_project_iam_member" "pks_master_node_compute_security_admin" {
  project = "${var.project}"
  role    = "roles/compute.securityAdmin"
  member  = "serviceAccount:${google_service_account.pks_master_node_service_account.email}"
}

resource "google_project_iam_member" "pks_master_node_iam_service_account_actor" {
  project = "${var.project}"
  role    = "roles/iam.serviceAccountActor"
  member  = "serviceAccount:${google_service_account.pks_master_node_service_account.email}"
}

resource "google_project_iam_member" "pks_worker_node_compute_viewer" {
  project = "${var.project}"
  role    = "roles/compute.viewer"
  member  = "serviceAccount:${google_service_account.pks_worker_node_service_account.email}"
}
