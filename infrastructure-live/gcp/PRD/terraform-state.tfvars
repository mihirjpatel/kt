terragrunt = {
  remote_state {
    backend = "gcs"

    config {
      bucket  = "p-artnet-terraform-admin"
      prefix  = "${path_relative_to_include()}/terraform.tfstate"
      project = "p-artnet-terraform-admin"
    }
  }
}
