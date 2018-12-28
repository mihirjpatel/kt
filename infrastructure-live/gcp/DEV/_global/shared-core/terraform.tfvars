terragrunt = {
  terraform {
    source = "git::git@github.com:artnetworldwide/terraform-modules.git//gcp/modules/shared-core?ref=v3.3.3"

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

shared_core_project_name = "tf-dev-shared-core"

storage_admin_service_account = "shared-core-storage-admin"

gtm_service_account = "gtm-service-account"

helm_repo_bucket = "artnet-dev-helm-repository"

static_artifacts_bucket = "artnet-dev-static-artifacts-repository"
