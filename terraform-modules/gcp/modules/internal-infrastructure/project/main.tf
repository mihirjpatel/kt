provider "google" {
  region = "${var.region}"
  zone   = "${var.zone}"
}

resource "random_id" "random" {
  prefix      = "${var.project_name}-"
  byte_length = "3"
}

resource "google_project" "project" {
  name                = "${var.project_name}"
  project_id          = "${random_id.random.hex}"
  folder_id           = "${var.folder_id}"
  billing_account     = "${var.billing_account}"
  auto_create_network = false

  lifecycle {
    prevent_destroy = true
  }
}


resource "google_project_service" "project_service" {
  count   = "${length(var.project_services)}"
  project = "${google_project.project.project_id}"
  service = "${element(var.project_services, count.index)}"

  # Do not disable the service on destroy. On destroy, we are going to
  # destroy the project, but we need the APIs available to destroy the
  # underlying resources.
  disable_on_destroy = false
}

