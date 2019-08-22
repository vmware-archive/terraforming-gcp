/*
################
# PLEASE READ! #
################

These firewall rules are intended to help
keep this doc up-to-date:
https://docs.pivotal.io/pivotalcf/2-3/adminguide/routing-is.html#config-firewall

If you need to add any new ports to the allowed list, please submit a PR to the
docs repo to let customers know about the new port:
https://github.com/cloudfoundry/docs-cf-admin/blob/4.5/routing-is.html.md.erb

Also let the PAS RelEng team know so that they can add this as a breaking change to the PAS release notes

Thanks!
*/

locals {
  iso_seg_vm_tags = [
    "isolated-ha-proxy",
    "isolated-ha-proxy${var.replicated_suffix}",
    "isolated-router",
    "isolated-router${var.replicated_suffix}",
    "isolated-diego-cell",
    "isolated-diego-cell${var.replicated_suffix}",
  ]
}

/* This firewall allows traffic between VMs in the isolation segment. */
resource "google_compute_firewall" "isoseg-cf-internal-ingress" {
  count = "${var.count * var.with_firewalls}"

  direction = "INGRESS"
  name      = "${var.env_name}-isoseg-cf-internal-ingress"
  network   = "${var.network}"
  priority  = 997

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  source_tags = "${local.iso_seg_vm_tags}"
  target_tags = "${local.iso_seg_vm_tags}"
}

/* This firewall allows traffic on certain ports from cf to the isolation segment. */
resource "google_compute_firewall" "isoseg-cf-ingress" {
  count = "${var.count * var.with_firewalls}"

  name    = "${var.env_name}-isoseg-cf-ingress"
  network = "${var.network}"

  direction   = "INGRESS"
  source_tags = ["${var.env_name}-vms"]
  target_tags = "${local.iso_seg_vm_tags}"
  priority    = 998

  allow {
    protocol = "tcp"

    ports = [
      "22",   # SSH for debugging
      "1801", # rep.diego.rep.listen_addr_securable
      "8853", # bosh-dns.health.server.port
    ]
  }
}

/* This firewall denies traffic from cf to the isolation segment on all ports. */
resource "google_compute_firewall" "isoseg-block-cf-ingress" {
  count = "${var.count * var.with_firewalls}"

  name    = "${var.env_name}-isoseg-block-cf-ingress"
  network = "${var.network}"

  direction   = "INGRESS"
  source_tags = ["${var.env_name}-vms"]
  target_tags = "${local.iso_seg_vm_tags}"
  priority    = 999

  deny {
    protocol = "icmp"
  }

  deny {
    protocol = "tcp"
  }

  deny {
    protocol = "udp"
  }
}

/* This firewall allows traffic on certain ports from the isolation segment to cf. */
resource "google_compute_firewall" "cf-isoseg-egress" {
  count = "${var.count * var.with_firewalls}"

  name    = "${var.env_name}-cf-isoseg-egress"
  network = "${var.network}"

  direction   = "INGRESS"
  target_tags = ["${var.env_name}-vms"]
  source_tags = "${local.iso_seg_vm_tags}"
  priority    = 998

  allow {
    protocol = "tcp"

    ports = [
      "4222",  # bosh.nats.port
      "25250", # bosh.blobstore.port
      "25777", # bosh.registry.port
      "3000",  # routing-api.routing_api.port
      "3457",  # loggregator_agent.listening_port
      "4003",  # vxlan-policy-agent.policy_server.internal_listen_port
      "4103",  # silk-controller.listen_port
      "4222",  # nats.nats.port
      "4443",  # blobstore.blobstore.tls.port
      "8080",  # blobstore.blobstore.port, file_server.diego.file_server.listen_addr (PAS only)
      "8082",  # reverse_log_proxy_port
      "8084",  # file_server.diego.file_server.listen_addr (8080 is PAS)
      "8300",  # default consul server port
      "8301",  # default consul serf lan port
      "8302",  # default consul serf wan port
      "8443",  # uaa.ssl.port
      "8447",  # file_server.https_listen_addr
      "8844",  # credhub.port
      "8853",  # bosh-dns.health.server.port
      "8889",  # bbs.diego.bbs.listen_addr
      "8891",  # locket.diego.locket.listen_addr
      "9000",  # loggr-syslog-binding-cache.external_port
      "9022",  # cloud_controller_ng.cc.external_port
      "9023",  # cloud_controller_ng.cc.tls_port
      "9090",  # cc_uploader.http_port
      "9091",  # cc_uploader.https_port
    ]
  }

  allow {
    protocol = "udp"

    ports = [
      "8301", # default consul serf lan port
      "8302", # default consul serf wan port
      "8600", # default consul dns
    ]
  }
}

/* This firewall denies traffic from the isolation segment to cf on all ports. */
resource "google_compute_firewall" "cf-block-isoseg-egress" {
  count = "${var.count* var.with_firewalls}"

  name    = "${var.env_name}-cf-block-isoseg-egress"
  network = "${var.network}"

  direction   = "INGRESS"
  target_tags = ["${var.env_name}-vms"]    # the "isoseg-cf-internal-ingress" ensures iso seg VMs can still talk to each other
  source_tags = "${local.iso_seg_vm_tags}"
  priority    = 999

  deny {
    protocol = "icmp"
  }

  deny {
    protocol = "tcp"
  }

  deny {
    protocol = "udp"
  }
}
