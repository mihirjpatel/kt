provider "google" {
  region = "${var.region}"
  zone   = "${var.zone}"
}

data "terraform_remote_state" "project" {
  backend = "gcs"

  config = "${var.project_remote_state_config}"
}

resource "random_id" "random" {
  prefix      = "${var.db_instance_name}-"
  byte_length = "3"
}

resource "google_sql_database_instance" "master" {
  name = "${random_id.random.hex}"
  database_version = "${var.db_version_type}"
  project = "${data.terraform_remote_state.project.project_id}"
  settings {
    # Second-generation instance tiers are based on the machine
    # type. See argument reference below.
    tier = "${var.db_instance_tier}"
    
    backup_configuration {
      enabled = "true"
      start_time = "06:00"
    }
  }
}


resource "google_sql_user" "users" {
  name     = "${var.db_user_name}"
  instance = "${google_sql_database_instance.master.name}"
  password = "${var.db_user_password}"
  project = "${data.terraform_remote_state.project.project_id}"
}