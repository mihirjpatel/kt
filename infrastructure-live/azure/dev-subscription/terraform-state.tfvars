terragrunt = {
  remote_state {
    backend = "azurerm"

    config {
      storage_account_name = "artnetdevtfstate"
      container_name       = "terraform-state-sc"
      key                  = "${path_relative_to_include()}/terraform.tfstate"
      resource_group_name  = "terraform-state-rg"
    }
  }
}
