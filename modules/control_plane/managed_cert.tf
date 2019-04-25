resource "google_compute_managed_ssl_certificate" "credhub_managed_cert" {
  # WARNING: This will prevent this resource from being recreated, even if changes
  # are made. Its purpose is to bypass this bug while it's being fixed:
  # https://github.com/terraform-providers/terraform-provider-google-beta/pull/591
  lifecycle {
    ignore_changes = ["managed"]
  }

  name = "${var.env_name}-credhub-managed-cert"

  managed {
    domains = ["credhub.${var.dns_zone_dns_name}"]
  }
}

resource "google_compute_managed_ssl_certificate" "uaa_managed_cert" {
  # WARNING: This will prevent this resource from being recreated, even if changes
  # are made. Its purpose is to bypass this bug while it's being fixed:
  # https://github.com/terraform-providers/terraform-provider-google-beta/pull/591
  lifecycle {
    ignore_changes = ["managed"]
  }

  name = "${var.env_name}-uaa-managed-cert"

  managed {
    domains = ["uaa.${var.dns_zone_dns_name}"]
  }
}
