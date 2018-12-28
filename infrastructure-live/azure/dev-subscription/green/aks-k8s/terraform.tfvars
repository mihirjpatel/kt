terragrunt = {
  terraform {
    source = "git::git@github.com:artnetworldwide/terraform-modules.git//azure/modules/aks-k8s?ref=v2.0.0"

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

  dependencies {
    paths = ["../vnet-with-s2s-vpn"]
  }
}

k8s_agent_count = 3

k8s_ssh_public_key = "~/.ssh/id_rsa.pub"

