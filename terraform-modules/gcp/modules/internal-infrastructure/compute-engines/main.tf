// Configure the Google Cloud provider
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

resource "google_compute_address" "static" {
  name = "external-ip-${var.instance_name}"
  address_type="EXTERNAL"
  project = "${data.terraform_remote_state.project.project_id}"
}


// Create a new instance
resource "google_compute_instance" "compute" {
project = "${data.terraform_remote_state.project.project_id}"
name = "${var.instance_name}"
machine_type = "${var.machine_type}"
metadata_startup_script = "${var.metadata_startup_script}"
labels = "${merge(var.labels)}"
allow_stopping_for_update = true


  boot_disk {
    initialize_params {
      image = "${var.image_name}"
      size = "${var.boot_disk_size}"
    }
  }
 
 attached_disk {
       source      = "${var.attached_disk_name}"
 }


  network_interface {
    subnetwork = "${data.terraform_remote_state.vpc.vpc_subnetwork_name[0]}"
    subnetwork_project = "${data.terraform_remote_state.project.project_id}"

    access_config {
      // Ephemeral IP
      nat_ip = "${google_compute_address.static.address}"
  }

  }
}
