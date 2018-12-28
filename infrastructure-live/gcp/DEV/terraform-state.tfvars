terragrunt = {
  remote_state {
    backend = "gcs"

    config {
      bucket  = "artnet-terraform-admin"
      prefix  = "${path_relative_to_include()}/terraform.tfstate"
      project = "artnet-terraform-admin"
    }
  }
}
