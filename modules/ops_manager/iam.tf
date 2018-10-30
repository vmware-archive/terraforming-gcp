resource "google_service_account" "opsman_service_account" {
  account_id   = "${var.env_name}-opsman"
  display_name = "${var.env_name} Ops Manager VM Service Account"
}

resource "google_service_account_key" "opsman_service_account_key" {
  service_account_id = "${google_service_account.opsman_service_account.id}"
}

resource "google_project_iam_member" "opsman_iam_service_account_actor" {
  count   = "${var.create_iam_service_account_members}"
  project = "${var.project}"
  role    = "roles/iam.serviceAccountActor"
  member  = "serviceAccount:${google_service_account.opsman_service_account.email}"
}

resource "google_project_iam_member" "opsman_compute_instance_admin" {
  count   = "${var.create_iam_service_account_members}"
  project = "${var.project}"
  role    = "roles/compute.instanceAdmin"
  member  = "serviceAccount:${google_service_account.opsman_service_account.email}"
}

resource "google_project_iam_member" "opsman_compute_network_admin" {
  count   = "${var.create_iam_service_account_members}"
  project = "${var.project}"
  role    = "roles/compute.networkAdmin"
  member  = "serviceAccount:${google_service_account.opsman_service_account.email}"
}

resource "google_project_iam_member" "opsman_compute_storage_admin" {
  count   = "${var.create_iam_service_account_members}"
  project = "${var.project}"
  role    = "roles/compute.storageAdmin"
  member  = "serviceAccount:${google_service_account.opsman_service_account.email}"
}

resource "google_project_iam_member" "opsman_storage_admin" {
  count   = "${var.create_iam_service_account_members}"
  project = "${var.project}"
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.opsman_service_account.email}"
}
