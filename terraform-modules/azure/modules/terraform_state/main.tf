locals {
  extra_tags = {
    tag_version = 2
    iac         = "true"
    environment = "${var.environment}"
  }

  tags = "${merge(var.tags, local.extra_tags)}"
}

# resource group for the Terraform remote state storage account
resource "azurerm_resource_group" "resource_group" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"
  tags     = "${local.tags}"

  lifecycle {
    prevent_destroy = true
    ignore_changes  = ["tags.lastModifiedAt"]
  }
}

# storage account
resource "azurerm_storage_account" "storage_account" {
  name                      = "${var.storage_account_name}"
  resource_group_name       = "${azurerm_resource_group.resource_group.name}"
  location                  = "${azurerm_resource_group.resource_group.location}"
  account_kind              = "Storage"
  account_tier              = "Standard"
  account_replication_type  = "GRS"
  enable_file_encryption    = true
  enable_blob_encryption    = true
  enable_https_traffic_only = true
  tags                      = "${local.tags}"

  lifecycle {
    prevent_destroy = true
    ignore_changes  = ["tags.lastModifiedAt"]
  }
}

# storage container
resource "azurerm_storage_container" "storage_container" {
  name                  = "${var.storage_container_name}"
  resource_group_name   = "${azurerm_resource_group.resource_group.name}"
  storage_account_name  = "${azurerm_storage_account.storage_account.name}"
  container_access_type = "private"

  lifecycle {
    prevent_destroy = true
  }
}
