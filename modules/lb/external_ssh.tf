///****************
// * Diego SSH LB *
// ****************/

resource "google_compute_firewall" "cf-ssh" {
  name    = "${var.env_name}-cf-ssh"
  network = "${var.network}"

  allow {
    protocol = "tcp"
    ports    = ["2222"]
  }

  target_tags = ["${var.env_name}-cf-ssh"]
}

resource "google_compute_address" "cf-ssh" {
  name = "${var.env_name}-cf-ssh"
}

resource "google_compute_target_pool" "cf-ssh" {
  name = "${var.env_name}-cf-ssh"
}

resource "google_compute_forwarding_rule" "cf-ssh" {
  name        = "${var.env_name}-cf-ssh"
  target      = "${google_compute_target_pool.cf-ssh.self_link}"
  port_range  = "2222"
  ip_protocol = "TCP"
  ip_address  = "${google_compute_address.cf-ssh.address}"
}
