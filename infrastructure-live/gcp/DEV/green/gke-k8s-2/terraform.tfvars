terragrunt = {
  terraform {
    source = "git::git@github.com:artnetworldwide/terraform-modules.git//gcp/modules/gke-k8s?ref=v3.0.0"

    extra_arguments "common_var" {
      commands = ["${get_terraform_commands_that_need_vars()}"]

      arguments = [
        "-var-file=${get_tfvars_dir()}/../environment.tfvars",
        "-var-file=${get_tfvars_dir()}/../../folder.tfvars",
        "-var-file=${get_tfvars_dir()}/../../../org.tfvars",
      ]
    }
  }

  include {
    path = "${find_in_parent_folders("terraform-state.tfvars")}"
  }
}

k8s_cluster_name = "cluster-2"

k8s_subnet_name = "k8s-nodes-2"

cluster_ipv4_cidr = "10.27.0.0/16"

k8s_secondary_ip_range_pods = "k8s-pods-2"

k8s_secondary_ip_range_services = "k8s-svcs-2"

k8s_version = "1.10.6-gke.3"

k8s_admin_username = "admin"

k8s_node_machine_type = "n1-standard-1"

static_web_bucket = "artnet-dev-static-site-cluster-2"

storage_admin_service_account = "gke-k8s-2-storage-admin-acc"

static_web_bucket_force_destroy = true
