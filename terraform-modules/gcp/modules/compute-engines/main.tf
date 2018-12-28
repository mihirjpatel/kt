// Configure the Google Cloud provider
provider "google" {
  region = "${var.region}"
  zone   = "${var.zone}"
}


data "terraform_remote_state" "vpc_project" {
  backend = "gcs"

  config = "${var.shared_vpc_project_remote_state_config}"
}

resource "google_compute_address" "static" {
  name = "external-ip-${var.instance_name}"
  address_type="EXTERNAL"
}


// Create a new instance
resource "google_compute_instance" "compute" {
project = "${data.terraform_remote_state.vpc_project.shared_vpc_project_id}"
name = "${var.instance_name}"
machine_type = "${var.machine_type}"
metadata_startup_script = "${var.metadata_startup_script}"
labels = "${merge(var.labels)}"


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
    subnetwork = "${data.terraform_remote_state.vpc_project.subnet_names[0]}"
    subnetwork_project = "${data.terraform_remote_state.vpc_project.shared_vpc_project_id}"

    access_config {
      // Ephemeral IP
      nat_ip = "${google_compute_address.static.address}"
  }

  }
}
