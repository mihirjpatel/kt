terragrunt = {
  terraform {
    source = "./../../../../../terraform-modules/gcp/modules/internal-infrastructure/project/"

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

project_services = [    
    "container.googleapis.com",
    "containerregistry.googleapis.com",
    "iam.googleapis.com",
    "sqladmin.googleapis.com"
    ]