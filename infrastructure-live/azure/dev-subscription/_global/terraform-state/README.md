# terraform-state

Creates an Azure storage account and container to be used for storing [lockable Terraform remote state](https://www.terraform.io/docs/backends/types/azurerm.html).

The storage is used by all other modules, so this needs to run first.

> WARNING: there is no shared state for the terraform-state. If the local state is lost, use `terragrunt import` to re-create it