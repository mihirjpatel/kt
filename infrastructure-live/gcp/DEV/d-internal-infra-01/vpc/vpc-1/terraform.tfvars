terragrunt = {
  terraform {
    source = "./../../../../../../terraform-modules/gcp/modules/internal-infrastructure/vpc/"

    extra_arguments "common_var" {
      commands = ["${get_terraform_commands_that_need_vars()}"]

      arguments = [
        "-var-file=${get_tfvars_dir()}/../../environment.tfvars",
        "-var-file=${get_tfvars_dir()}/../../../folder.tfvars",
        "-var-file=${get_tfvars_dir()}/../../../../org.tfvars",
      ]
    }
  }

  include {
    path = "${find_in_parent_folders("terraform-state.tfvars")}"
  }
}



project_remote_state_config = {
  project = "artnet-terraform-admin"
  bucket  = "artnet-terraform-admin"
  prefix  = "d-internal-infra-01/project/terraform.tfstate"
}

