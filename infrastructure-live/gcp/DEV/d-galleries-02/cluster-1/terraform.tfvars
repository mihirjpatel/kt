terragrunt = {
  terraform {
    source = "git::git@github.com:artnetworldwide/terraform-modules.git//gcp/modules/gke-k8s?ref=v3.3.1"

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

k8s_cluster_name = "cluster-1"

k8s_subnet_name = "k8s-nodes-1"

cluster_ipv4_cidr = "10.30.0.0/16"

k8s_secondary_ip_range_pods = "k8s-pods-1"

k8s_secondary_ip_range_services = "k8s-svcs-1"

k8s_version = "1.10.6-gke.3"

k8s_admin_username = "admin"

k8s_node_machine_type = "n1-standard-1"

static_web_bucket = "d-galleries-02-cluster-1"

storage_admin_service_account = "cluster-1-storage-admin-acc"

cluster_deployer_service_account = "cluster-1-deploy-svc-acc"

static_web_bucket_force_destroy = true

# Please make sure the prefix is correct
# It should point to the remote state for the VPC. We need to look up project_id of the
# Google cloud project where the VPC was created so that we can place the Kubernetes cluster
# into the same project
shared_vpc_project_remote_state_config = {
  project = "artnet-terraform-admin"
  bucket  = "artnet-terraform-admin"
  prefix  = "d-galleries-02/shared-vpc/terraform.tfstate"
}
