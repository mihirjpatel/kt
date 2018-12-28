terragrunt = {
  terraform {
    source = "./../../../../../../terraform-modules/gcp/modules/internal-infrastructure/cloud-sql/"

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


db_instance_name = "p-atlassian-01"
db_instance_tier = "db-custom-4-16384"
db_version_type = "POSTGRES_9_6"
db_user_name = "atlassianusr"


project_remote_state_config = {
  project = "p-artnet-terraform-admin"
  bucket  = "p-artnet-terraform-admin"
  prefix  = "p-internal-infra-01/project/terraform.tfstate"
}
