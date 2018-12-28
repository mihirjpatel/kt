provider "google" {
  region = "${var.region}"
  zone   = "${var.zone}"
}

data "terraform_remote_state" "project" {
  backend = "gcs"

  config = "${var.project_remote_state_config}"
}

data "terraform_remote_state" "vpc" {
  backend = "gcs"

  config = "${var.vpc_remote_state_config}"
}



/*
 * ----------VPN Connection----------
 */

resource "google_compute_address" "vpn_gateway_ip" {
  name    = "${var.vpn_tunnel_id}-gateway-ip"
  region  = "${var.region}"
  project = "${data.terraform_remote_state.project.project_id}"
}

#resource "google_dns_record_set" "a" {
#  #e.g. d-vpn-tunnel-1.gcp.artnet-dev.com.
#  name         = "${var.vpn_tunnel_id}-gateway.${var.dns_zone_dns_name}"
#  managed_zone = "${var.dns_zone_name}"
#  type         = "A"
#  ttl          = 300
#  project      = "${data.terraform_remote_state.shared_core_project_remote_state.shared_core_project_id}"
#
#  rrdatas = ["${google_compute_address.vpn_gateway_ip.address}"]
#}

resource "google_compute_vpn_gateway" "vpn_gateway" {
  name    = "${var.vpn_tunnel_id}-gateway"
  network = "${data.terraform_remote_state.vpc.vpc_network_name}"
  region  = "${var.region}"
  project = "${data.terraform_remote_state.project.project_id}"
}

resource "google_compute_forwarding_rule" "fr_esp" {
  name        = "fr-esp"
  ip_protocol = "ESP"
  ip_address  = "${google_compute_address.vpn_gateway_ip.address}"
  target      = "${google_compute_vpn_gateway.vpn_gateway.self_link}"
  project     = "${data.terraform_remote_state.project.project_id}"
}

resource "google_compute_forwarding_rule" "fr_udp500" {
  name        = "fr-udp500"
  ip_protocol = "UDP"
  port_range  = "500-500"
  ip_address  = "${google_compute_address.vpn_gateway_ip.address}"
  target      = "${google_compute_vpn_gateway.vpn_gateway.self_link}"
  project     = "${data.terraform_remote_state.project.project_id}"
}

resource "google_compute_forwarding_rule" "fr_udp4500" {
  name        = "fr-udp4500"
  ip_protocol = "UDP"
  port_range  = "4500-4500"
  ip_address  = "${google_compute_address.vpn_gateway_ip.address}"
  target      = "${google_compute_vpn_gateway.vpn_gateway.self_link}"
  project     = "${data.terraform_remote_state.project.project_id}"
}

/*
 * ----------VPN Tunnel1----------
 */

resource "google_compute_router" "cloud_router" {
  name    = "${var.vpn_tunnel_id}-cloud-router"
  network = "${data.terraform_remote_state.vpc.vpc_network_name}"

  project = "${data.terraform_remote_state.project.project_id}"
  region  = "${var.region}"

  bgp {
    asn            = "${var.cloud_router_asn}"
    advertise_mode = "DEFAULT"
  }
}

resource "google_compute_router_peer" "onprem_peer" {
  project = "${data.terraform_remote_state.project.project_id}"
  region  = "${var.region}"

  name            = "onprem-peer"
  router          = "${google_compute_router.cloud_router.name}"
  region          = "${var.region}"
  peer_ip_address = "${var.onprem_device_link_local_ip}"
  peer_asn        = "${var.onprem_peer_asn}"

  # advertised_route_priority = 100
  interface = "${google_compute_router_interface.cloud_router_interface.name}"
}

resource "google_compute_router_interface" "cloud_router_interface" {
  project = "${data.terraform_remote_state.project.project_id}"
  region  = "${var.region}"

  name       = "${var.vpn_tunnel_id}-cloud-router-interface"
  router     = "${google_compute_router.cloud_router.name}"
  ip_range   = "${var.cloud_router_link_local_ip}/30"
  vpn_tunnel = "${google_compute_vpn_tunnel.vpn_tunnel_1.name}"
}

resource "google_compute_vpn_tunnel" "vpn_tunnel_1" {
  project = "${data.terraform_remote_state.project.project_id}"
  region  = "${var.region}"

  name          = "${var.vpn_tunnel_id}-tunnel"
  peer_ip       = "${var.onprem_device_public_ip}"
  shared_secret = "${var.vpn_connection_shared_key}"
  ike_version   = 2

  target_vpn_gateway = "${google_compute_vpn_gateway.vpn_gateway.self_link}"

  router = "${google_compute_router.cloud_router.name}"

  depends_on = [
    "google_compute_forwarding_rule.fr_esp",
    "google_compute_forwarding_rule.fr_udp500",
    "google_compute_forwarding_rule.fr_udp4500",
  ]
}

resource "google_compute_shared_vpc_host_project" "host" {
  project = "${data.terraform_remote_state.project.project_id}"
}
