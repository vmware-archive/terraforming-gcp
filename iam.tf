resource "google_service_account" "opsman_service_account" {
  account_id   = "${var.env_name}-opsman"
  display_name = "${var.env_name} Ops Manager VM Service Account"
}

resource "google_project_iam_member" "opsman_iam_service_account_actor" {
  project = "${var.project}"
  role    = "roles/iam.serviceAccountActor"
  member  = "serviceAccount:${google_service_account.opsman_service_account.email}",
}

resource "google_project_iam_member" "opsman_compute_instance_admin" {
  project = "${var.project}"
  role    = "roles/compute.instanceAdmin"
  member  = "serviceAccount:${google_service_account.opsman_service_account.email}",
}

resource "google_project_iam_member" "opsman_compute_network_admin" {
  project = "${var.project}"
  role    = "roles/compute.networkAdmin"
  member  = "serviceAccount:${google_service_account.opsman_service_account.email}",
}

resource "google_project_iam_member" "opsman_compute_storage_admin" {
  project = "${var.project}"
  role    = "roles/compute.storageAdmin"
  member  = "serviceAccount:${google_service_account.opsman_service_account.email}",
}

resource "google_project_iam_member" "opsman_storage_admin" {
  project = "${var.project}"
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.opsman_service_account.email}",
}
