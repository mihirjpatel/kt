terraform {
  backend "azurerm" {
    storage_account_name = "gjcpf2wd78xxkvygreen"       #notice 'green' at the end
    container_name       = "sc-terraform-state"
    key                  = "keyvault.terraform.tfstate"
  }
}

locals {
  location    = "${var.location}"
  environment = "${var.environment}"
  project     = "${var.project}"

  resource_group_name = "rg-keyvault-${var.environment}"

  tags = {
    project        = "${var.project}"
    user           = "${var.user_running_terraform}"
    environment    = "${var.environment}"
    lastModifiedAt = "${timestamp()}"
  }
}

resource "azurerm_resource_group" "rg_key_vault" {
  name     = "${local.resource_group_name}"
  location = "${local.location}"
  tags     = "${local.tags}"

  lifecycle {
    ignore_changes = ["tags.lastModifiedAt", "tags.user"]
  }
}

resource "azurerm_key_vault" "key_vault" {
  name                = "key-vault-${local.environment}"
  location            = "${azurerm_resource_group.rg_key_vault.location}"
  resource_group_name = "${azurerm_resource_group.rg_key_vault.name}"

  sku {
    name = "standard"
  }

  tenant_id = "f99ef0be-7868-495e-b90c-12dee38c1fdc" # The Directory ID of Artnet's Azure AD

  access_policy {
    tenant_id = "f99ef0be-7868-495e-b90c-12dee38c1fdc" # The Directory ID of Artnet's Azure AD
    object_id = "882c7022-ef8b-41b0-a558-45afce570c21" #the ID of Azure AD group '_AzureKeyVault_Admins'

    certificate_permissions = [
      "create",
      "delete",
      "deleteissuers",
      "get",
      "getissuers",
      "import",
      "list",
      "listissuers",
      "managecontacts",
      "manageissuers",
      "setissuers",
      "update",
    ]

    key_permissions = [
      "backup",
      "create",
      "decrypt",
      "delete",
      "encrypt",
      "get",
      "import",
      "list",
      "purge",
      "recover",
      "restore",
      "sign",
      "unwrapKey",
      "update",
      "verify",
      "wrapKey",
    ]

    secret_permissions = [
      "backup",
      "delete",
      "get",
      "list",
      "purge",
      "recover",
      "restore",
      "set",
    ]
  }

  enabled_for_deployment          = true
  enabled_for_template_deployment = true
  tags                            = "${local.tags}"

  lifecycle {
    ignore_changes = ["tags.lastModifiedAt", "tags.user"]
  }
}
