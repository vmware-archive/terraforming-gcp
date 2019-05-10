provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  account_key_pem = "${tls_private_key.private_key.private_key_pem}"
  email_address   = "${var.registration_email}"
}

resource "acme_certificate" "certificate" {
  account_key_pem = "${acme_registration.reg.account_key_pem}"
  common_name     = "${var.root_domain}"

  subject_alternative_names = [
    "uaa.${var.root_domain}",
    "credhub.${var.root_domain}",
  ]

  dns_challenge {
    provider = "gcloud"

    config {
      GCE_PROJECT         = "${var.project}"
      GCE_SERVICE_ACCOUNT = "${var.service_account_key}"
    }
  }
}
