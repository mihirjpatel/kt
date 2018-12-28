terragrunt = {
  terraform {
    source = "git::git@github.com:artnetworldwide/terraform-modules.git//sonicwall/modules/gpc-vpn-tunnel?ref=feature/add-version-of-sonicwall-script-with-one-subnet"

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

sonicwall_host = "192.168.1.1"

sonicwall_name = "ARTNET-NY-SNWL"
