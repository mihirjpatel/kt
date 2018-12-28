terragrunt = {
  terraform {
    source = "git::git@github.com:artnetworldwide/terraform-modules.git//gcp/modules/shared-vpc?ref=v3.0.0"

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

shared_vpc_project_name = "d-galleries-01"

db_subnet_range = "10.7.0.0/16"
