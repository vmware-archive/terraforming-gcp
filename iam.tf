resource "google_service_account" "opsman_service_account" {
  count = "${local.pcf_count}"
  account_id   = "${var.env_name}-opsman"
  display_name = "${var.env_name} Ops Manager VM Service Account"
}

resource "google_project_iam_binding" "iam_service_account_actor" {
  count = "${local.pcf_count}"
  project = "${var.project}"
  role    = "roles/iam.serviceAccountActor"

  members = [
    "serviceAccount:${google_service_account.opsman_service_account.email}",
  ]
}

resource "google_project_iam_binding" "compute_instance_admin" {
  count = "${local.pcf_count}"
  project = "${var.project}"
  role    = "roles/compute.instanceAdmin"

  members = [
    "serviceAccount:${google_service_account.opsman_service_account.email}",
  ]
}

resource "google_project_iam_binding" "compute_network_admin" {
  count = "${local.pcf_count}"
  project = "${var.project}"
  role    = "roles/compute.networkAdmin"

  members = [
    "serviceAccount:${google_service_account.opsman_service_account.email}",
  ]
}

resource "google_project_iam_binding" "compute_storage_admin" {
  count = "${local.pcf_count}"
  project = "${var.project}"
  role    = "roles/compute.storageAdmin"

  members = [
    "serviceAccount:${google_service_account.opsman_service_account.email}",
  ]
}

resource "google_project_iam_binding" "storage_admin" {
  count = "${local.pcf_count}"
  project = "${var.project}"
  role    = "roles/storage.admin"

  members = [
    "serviceAccount:${google_service_account.opsman_service_account.email}",
  ]
}
