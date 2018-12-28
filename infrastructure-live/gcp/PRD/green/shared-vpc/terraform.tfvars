terragrunt = {
  terraform {
    source = "git::git@github.com:artnetworldwide/terraform-modules.git//gcp/modules/shared-vpc?ref=v3.2.1"

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

vpn_tunnel_id = "p-vpn-tunnel-1"

shared_vpc_project_name = "p-galleries-01"

onprem_device_public_ip = "64.147.121.2"

onprem_device_link_local_ip = "169.254.26.2"

onprem_peer_asn = "65002"

cloud_router_link_local_ip = "169.254.26.1"

cloud_router_asn = "65026"

db_subnet_range = "10.9.0.0/16"
