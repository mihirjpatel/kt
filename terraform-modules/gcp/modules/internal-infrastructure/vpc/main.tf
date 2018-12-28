provider "google" {
  region = "${var.region}"
  zone   = "${var.zone}"
}

data "terraform_remote_state" "project" {
  backend = "gcs"

  config = "${var.project_remote_state_config}"
}


resource "google_compute_network" "vpc" {
  name                    = "vpc-1"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
  project                 = "${data.terraform_remote_state.project.project_id}"
}


resource "google_compute_subnetwork" "subnets_primary_only" {
  count                    = "${length(var.subnet_names)}"
  name                     = "${element(var.subnet_names, count.index)}"
  ip_cidr_range            = "${element(var.subnet_cidrs, count.index)}"
  region                   = "${var.region}"
  private_ip_google_access = true
  network                  = "${google_compute_network.vpc.self_link}"
  project                  = "${data.terraform_remote_state.project.project_id}"
}


resource "google_compute_firewall" "office-public" {
  name    = "office-public"
  network = "${google_compute_network.vpc.self_link}"

  priority           = 1000
  direction          = "INGRESS"
  source_ranges = ["${var.onprem_device_public_ip}"]

  allow = {
    protocol = "all"
  }

  project = "${data.terraform_remote_state.project.project_id}"
}

resource "google_compute_firewall" "office-local" {
  name    = "office-local"
  network = "${google_compute_network.vpc.self_link}"

  priority           = 1000
  direction          = "INGRESS"
  source_ranges = ["192.168.0.0/23"]

  allow = {
    protocol = "all"
  }

  project = "${data.terraform_remote_state.project.project_id}"
}
