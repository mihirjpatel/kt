provider "google" {
  region = "${var.region}"
  zone   = "${var.zone}"
}

data "terraform_remote_state" "vpc_project" {
  backend = "gcs"

  config = "${var.shared_vpc_project_remote_state_config}"
}

resource "google_container_cluster" "k8s_cluster" {
  name               = "${var.k8s_cluster_name}"
  zone               = "${var.zone}"
  project            = "${data.terraform_remote_state.vpc_project.shared_vpc_project_id}"
  initial_node_count = 3

  enable_kubernetes_alpha = false
  enable_legacy_abac      = false

  addons_config {
    http_load_balancing {
      disabled = false
    }

    kubernetes_dashboard {
      disabled = true
    }
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = "03:00"
    }
  }

  network    = "${data.terraform_remote_state.vpc_project.shared_vpc_network_name}"
  subnetwork = "${var.k8s_subnet_name}"

  cluster_ipv4_cidr = "${var.cluster_ipv4_cidr}"

  ip_allocation_policy {
    cluster_secondary_range_name  = "${var.k8s_secondary_ip_range_pods}"
    services_secondary_range_name = "${var.k8s_secondary_ip_range_services}"
  }

  min_master_version = "${var.k8s_version}"

  master_auth {
    username = "${var.k8s_admin_username}"
    password = "${var.k8s_admin_password}"
  }

  node_config {
    disk_size_gb = "${var.k8s_node_disk_size_gb}"
    disk_type    = "pd-standard"
    machine_type = "${var.k8s_node_machine_type}"
    preemptible  = false

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

resource "google_service_account" "cluster_deployer" {
  account_id   = "${var.cluster_deployer_service_account}"
  display_name = "${var.cluster_deployer_service_account}"
  project      = "${data.terraform_remote_state.vpc_project.shared_vpc_project_id}"
}

resource "google_service_account_key" "cluster_deployer" {
  depends_on = ["google_service_account.cluster_deployer"]
  service_account_id = "${google_service_account.cluster_deployer.name}"
}

resource "google_project_iam_member" "cluster_deployer" {
  role       = "roles/container.developer"
  member     = "serviceAccount:${google_service_account.cluster_deployer.email}"
  depends_on = ["google_service_account.cluster_deployer"]
  project    = "${data.terraform_remote_state.vpc_project.shared_vpc_project_id}"
}

resource "google_service_account" "storage_admin" {
  account_id   = "${var.storage_admin_service_account}"
  display_name = "${var.storage_admin_service_account}"
  project      = "${data.terraform_remote_state.vpc_project.shared_vpc_project_id}"
}

resource "google_service_account_key" "storage_admin" {
  depends_on = ["google_service_account.storage_admin"]
  service_account_id = "${google_service_account.storage_admin.name}"
}

resource "google_project_iam_member" "storage_admin_service_account" {
  role       = "roles/storage.objectAdmin"
  member     = "serviceAccount:${google_service_account.storage_admin.email}"
  depends_on = ["google_service_account.storage_admin"]
  project    = "${data.terraform_remote_state.vpc_project.shared_vpc_project_id}"
}

resource "google_storage_bucket" "static_web_bucket" {
  name          = "${var.static_web_bucket}"
  location      = "${var.default_bucket_location}"
  force_destroy = "${var.static_web_bucket_force_destroy}"
  project       = "${data.terraform_remote_state.vpc_project.shared_vpc_project_id}"

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}

resource "google_storage_bucket_iam_member" "static_web_bucket" {
  bucket     = "${var.static_web_bucket}"
  role       = "roles/storage.objectViewer"
  member     = "allUsers"
  depends_on = ["google_storage_bucket.static_web_bucket"]
}

resource "google_project_service" "monitoring" {
 project = "${data.terraform_remote_state.vpc_project.shared_vpc_project_id}"
 service = "monitoring.googleapis.com"
}

resource "google_project_service" "logging" {
  project = "${data.terraform_remote_state.vpc_project.shared_vpc_project_id}"
  service = "logging.googleapis.com"
}

resource "null_resource" "istio" {
  depends_on = ["google_container_cluster.k8s_cluster"]
  provisioner "local-exec" {
    command = "./configure_k8s.sh"
    environment {
      GOOGLE_PROJECT_ID="${data.terraform_remote_state.vpc_project.shared_vpc_project_id}"
      CLUSTER_NAME="${var.k8s_cluster_name}"
      GOOGLE_COMPUTE_ZONE="${var.zone}"
      SERVICE_TYPE="ClusterIP"
      INGRESS_SERVICE_TYPE="LoadBalancer"
    }
  }
}

resource "null_resource" "point_deployment_to_new_cluster" {
  depends_on = ["google_container_cluster.k8s_cluster", "null_resource.istio"]
  provisioner "local-exec" {
    command = "${path.module}/register_new_k8s.sh"
    environment {
      K8_PROJECT_ID="${data.terraform_remote_state.vpc_project.shared_vpc_project_id}"
      K8_CLUSTER_NAME="${var.k8s_cluster_name}"
      K8_COMPUTE_ZONE="${var.zone}"
      K8_SERVICE_ACCOUNT="${base64decode(google_service_account_key.cluster_deployer.private_key)}"
      STATIC_SITE_SERVICE_ACCOUNT="${base64decode(google_service_account_key.storage_admin.private_key)}"
      STATIC_SITE_BUCKET_NAME="${google_storage_bucket.static_web_bucket.name}"
    }
  }
}
