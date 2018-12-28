locals {
  location = "${var.location}"

  resource_group_name = "rg-globals"
  azure_dns_zone      = "${var.azure_dns_zone}"

  storage_account_name   = "artnetdevteam"
  storage_container_name = "www"

  tags = {
    project        = "${var.project}"
    user           = "${var.user_running_terraform}"
    environment    = "${var.environment}"
    lastModifiedAt = "${timestamp()}"
  }
}


# Resource group for global objects
resource "azurerm_resource_group" "rg_globals" {
  name     = "${local.resource_group_name}"
  location = "${local.location}"
  tags     = "${local.tags}"

  lifecycle {
    prevent_destroy = true
    ignore_changes  = ["tags.lastModifiedAt", "tags.user"]
  }
}

# An NS record for this DNS zone needs to be manually added to the parent DNS zone (artnet.com)
resource "azurerm_dns_zone" "dns_zone" {
  name                = "${local.azure_dns_zone}"
  resource_group_name = "${azurerm_resource_group.rg_globals.name}"
  tags                = "${local.tags}"

  lifecycle {
    prevent_destroy = true
    ignore_changes  = ["tags.lastModifiedAt", "tags.user"]
  }
}

# storage account
resource "azurerm_storage_account" "storage_account" {
  name                      = "${local.storage_account_name}"
  resource_group_name       = "${azurerm_resource_group.rg_globals.name}"
  location                  = "${local.location}"
  account_kind              = "Storage"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_file_encryption    = true
  enable_blob_encryption    = true
  enable_https_traffic_only = true
  tags                      = "${local.tags}"

  lifecycle {
    prevent_destroy = false
    ignore_changes  = ["tags.lastModifiedAt"]
  }
}

# storage container
resource "azurerm_storage_container" "storage_container" {
  name                  = "${local.storage_container_name}"
  resource_group_name   = "${azurerm_resource_group.rg_globals.name}"
  storage_account_name  = "${azurerm_storage_account.storage_account.name}"
  container_access_type = "private"

  lifecycle {
    prevent_destroy = false
  }
}