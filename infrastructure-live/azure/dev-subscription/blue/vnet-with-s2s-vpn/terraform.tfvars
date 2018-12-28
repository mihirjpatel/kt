terragrunt = {
  terraform {
    source = "git::git@github.com:artnetworldwide/terraform-modules.git//azure/modules/vnet?ref=v2.0.0"

    extra_arguments "common_var" {
      commands = ["${get_terraform_commands_that_need_vars()}"]

      arguments = ["-var-file=${get_tfvars_dir()}/../environment.tfvars",
        "-var-file=${get_tfvars_dir()}/../../subscription.tfvars",
      ]
    }
  }

  include {
    path = "${find_in_parent_folders("terraform-state.tfvars")}"
  }
}

include_gateways_for_vpn_tunnel = 1

include_vpn_connection = 1
