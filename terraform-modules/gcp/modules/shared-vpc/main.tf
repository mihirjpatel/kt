provider "google" {
  region = "${var.region}"
  zone   = "${var.zone}"
}

data "terraform_remote_state" "shared_core_project_remote_state" {
  backend = "gcs"

  config = "${var.shared_core_project_remote_state_config}"
}

resource "random_id" "random" {
  prefix      = "${var.shared_vpc_project_name}-"
  byte_length = "3"
}

resource "google_project" "shared_vpc_project" {
  name                = "${var.shared_vpc_project_name}"
  project_id          = "${random_id.random.hex}"
  folder_id           = "${var.folder_id}"
  billing_account     = "${var.billing_account}"
  auto_create_network = false
}

resource "google_project_service" "shared_vpc_project_service" {
  count   = "${length(var.shared_vpc_project_services)}"
  project = "${google_project.shared_vpc_project.project_id}"
  service = "${element(var.shared_vpc_project_services, count.index)}"

  # Do not disable the service on destroy. On destroy, we are going to
  # destroy the project, but we need the APIs available to destroy the
  # underlying resources.
  disable_on_destroy = false
}

resource "google_compute_network" "vpc" {
  name                    = "vpc-1"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
  project                 = "${google_project.shared_vpc_project.project_id}"
}

resource "google_compute_firewall" "allow_sql_to_on_prem" {
  name    = "allow-sql-to-onprem"
  network = "${google_compute_network.vpc.self_link}"

  priority           = 1000
  direction          = "EGRESS"
  destination_ranges = ["${var.db_subnet_range}"]

  allow = {
    protocol = "tcp"
    ports    = ["1433"]
  }

  project = "${google_project.shared_vpc_project.project_id}"
}

resource "google_compute_subnetwork" "subnets_primary_only" {
  count                    = "${length(var.secondary_ip_range_gke_cluster_pods_names) == 0 ? length(var.subnet_names): 0}"
  name                     = "${element(var.subnet_names, count.index)}"
  ip_cidr_range            = "${element(var.subnet_cidrs, count.index)}"
  region                   = "${var.region}"
  private_ip_google_access = true
  network                  = "${google_compute_network.vpc.self_link}"
  project                  = "${google_project.shared_vpc_project.project_id}"
}

resource "google_compute_subnetwork" "subnets_primary_secondary" {
  count                    = "${length(var.secondary_ip_range_gke_cluster_pods_names) > 0 ? length(var.subnet_names): 0}"
  name                     = "${element(var.subnet_names, count.index)}"
  ip_cidr_range            = "${element(var.subnet_cidrs, count.index)}"
  region                   = "${var.region}"
  private_ip_google_access = true
  network                  = "${google_compute_network.vpc.self_link}"
  project                  = "${google_project.shared_vpc_project.project_id}"

  secondary_ip_range = [
    {
      range_name    = "${element(var.secondary_ip_range_gke_cluster_pods_names, count.index)}"
      ip_cidr_range = "${element(var.secondary_ip_range_gke_cluster_pods_cidrs, count.index)}"
    },
    {
      range_name    = "${element(var.secondary_ip_range_gke_cluster_services_names, count.index)}"
      ip_cidr_range = "${element(var.secondary_ip_range_gke_cluster_services_cidrs, count.index)}"
    },
  ]
}

/*
 * ----------VPN Connection----------
 */

resource "google_compute_address" "vpn_gateway_ip" {
  name    = "${var.vpn_tunnel_id}-gateway-ip"
  region  = "${var.region}"
  project = "${google_project.shared_vpc_project.project_id}"
}

resource "google_dns_record_set" "a" {
  #e.g. d-vpn-tunnel-1.gcp.artnet-dev.com.
  name         = "${var.vpn_tunnel_id}-gateway.${var.dns_zone_dns_name}"
  managed_zone = "${var.dns_zone_name}"
  type         = "A"
  ttl          = 300
  project      = "${data.terraform_remote_state.shared_core_project_remote_state.shared_core_project_id}"

  rrdatas = ["${google_compute_address.vpn_gateway_ip.address}"]
}

resource "google_compute_vpn_gateway" "vpn_gateway" {
  name    = "${var.vpn_tunnel_id}-gateway"
  network = "${google_compute_network.vpc.self_link}"
  region  = "${var.region}"
  project = "${google_project.shared_vpc_project.project_id}"
}

resource "google_compute_forwarding_rule" "fr_esp" {
  name        = "fr-esp"
  ip_protocol = "ESP"
  ip_address  = "${google_compute_address.vpn_gateway_ip.address}"
  target      = "${google_compute_vpn_gateway.vpn_gateway.self_link}"
  project     = "${google_project.shared_vpc_project.project_id}"
}

resource "google_compute_forwarding_rule" "fr_udp500" {
  name        = "fr-udp500"
  ip_protocol = "UDP"
  port_range  = "500-500"
  ip_address  = "${google_compute_address.vpn_gateway_ip.address}"
  target      = "${google_compute_vpn_gateway.vpn_gateway.self_link}"
  project     = "${google_project.shared_vpc_project.project_id}"
}

resource "google_compute_forwarding_rule" "fr_udp4500" {
  name        = "fr-udp4500"
  ip_protocol = "UDP"
  port_range  = "4500-4500"
  ip_address  = "${google_compute_address.vpn_gateway_ip.address}"
  target      = "${google_compute_vpn_gateway.vpn_gateway.self_link}"
  project     = "${google_project.shared_vpc_project.project_id}"
}

/*
 * ----------VPN Tunnel1----------
 */

resource "google_compute_router" "cloud_router" {
  name    = "${var.vpn_tunnel_id}-cloud-router"
  network = "${google_compute_network.vpc.name}"

  project = "${google_project.shared_vpc_project.project_id}"
  region  = "${var.region}"

  bgp {
    asn            = "${var.cloud_router_asn}"
    advertise_mode = "DEFAULT"
  }
}

resource "google_compute_router_peer" "onprem_peer" {
  project = "${google_project.shared_vpc_project.project_id}"
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
  project = "${google_project.shared_vpc_project.project_id}"
  region  = "${var.region}"

  name       = "${var.vpn_tunnel_id}-cloud-router-interface"
  router     = "${google_compute_router.cloud_router.name}"
  ip_range   = "${var.cloud_router_link_local_ip}/30"
  vpn_tunnel = "${google_compute_vpn_tunnel.vpn_tunnel_1.name}"
}

resource "google_compute_vpn_tunnel" "vpn_tunnel_1" {
  project = "${google_project.shared_vpc_project.project_id}"
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
  project = "${google_project.shared_vpc_project.project_id}"
}
