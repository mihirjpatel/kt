provider "google" {
  region = "${var.region}"
  zone   = "${var.zone}"
}

resource "random_id" "random" {
  prefix      = "${var.shared_core_project_name}-"
  byte_length = "3"
}

resource "google_project" "shared_core_project" {
  name                = "${var.shared_core_project_name}"
  project_id          = "${random_id.random.hex}"
  folder_id           = "${var.folder_id}"
  billing_account     = "${var.billing_account}"
  auto_create_network = false

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_project_service" "shared_core_project_service" {
  count   = "${length(var.shared_core_project_services)}"
  project = "${google_project.shared_core_project.project_id}"
  service = "${element(var.shared_core_project_services, count.index)}"

  # Do not disable the service on destroy. On destroy, we are going to
  # destroy the project, but we need the APIs available to destroy the
  # underlying resources.
  disable_on_destroy = false
}

# need to wait for the APIs to be ready
resource "null_resource" "delay" {
  provisioner "local-exec" {
    command = "sleep 30"
  }

  triggers = {
    service_ids = "${join(",", google_project_service.shared_core_project_service.*.id)}"
  }
}

resource "google_dns_managed_zone" "dns_zone" {
  name     = "${var.dns_zone_name}"
  dns_name = "${var.dns_zone_dns_name}"
  project  = "${google_project.shared_core_project.project_id}"

  lifecycle {
    prevent_destroy = true
  }

  depends_on = ["null_resource.delay"]
}

resource "google_service_account" "storage_admin_service_account" {
  account_id   = "${var.storage_admin_service_account}"
  display_name = "${var.storage_admin_service_account}"
  project = "${google_project.shared_core_project.project_id}"
}

resource "google_service_account" "gtm_service_account" {
  account_id   = "${var.gtm_service_account}"
  display_name = "${var.gtm_service_account}"
  project = "${google_project.shared_core_project.project_id}"
}

resource "google_service_account_key" "storage_admin" {
  depends_on = ["google_service_account.storage_admin_service_account"]
  service_account_id = "${google_service_account.storage_admin_service_account.name}"
}

resource "google_project_iam_member" "storage_admin_service_account" {
  role = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.storage_admin_service_account.email}"
  depends_on = ["google_service_account.storage_admin_service_account"]
  project = "${google_project.shared_core_project.project_id}"
}

resource "google_storage_bucket" "helm_repo_bucket" {
  name     = "${var.helm_repo_bucket}"
  location = "${var.region}"
  project = "${google_project.shared_core_project.project_id}"
}

resource "google_storage_bucket" "tf_state_bucket" {
  name     = "${var.tf_state_bucket}"
  location = "${var.region}"
  project = "${google_project.shared_core_project.project_id}"
}

resource "google_storage_bucket_iam_member" "tf_state_bucket" {
  bucket     = "${var.tf_state_bucket}"
  role       = "roles/storage.objectViewer"
  member     = "allUsers"
  depends_on = ["google_storage_bucket.tf_state_bucket"]
}

resource "google_storage_bucket" "static_artifacts_bucket" {
  name     = "${var.static_artifacts_bucket}"
  location = "${var.region}"
  project = "${google_project.shared_core_project.project_id}"
}

resource "google_storage_bucket_iam_member" "helm_repo_bucket" {
  bucket     = "${var.helm_repo_bucket}"
  role       = "roles/storage.objectViewer"
  member     = "allUsers"
  depends_on = ["google_storage_bucket.helm_repo_bucket"]
}

resource "null_resource" "point_cicd_to_new_shared_core" {
  depends_on = ["google_storage_bucket.helm_repo_bucket", "google_service_account_key.storage_admin", "google_storage_bucket.static_artifacts_bucket"]
  provisioner "local-exec" {
    command = "${path.module}/register_new_shared_core.sh"
    environment {
      SHARED_CORE_PROJECT="${google_project.shared_core_project.project_id}"
      HELM_REPO_BUCKET_NAME="${var.helm_repo_bucket}"
      ARCHIVE_REPO_BUCKET_NAME="${var.static_artifacts_bucket}"
      SHARED_CORE_STORAGE_ADMIN_SERVICE_ACCOUNT="${base64decode(google_service_account_key.storage_admin.private_key)}"
    }
  }
}
