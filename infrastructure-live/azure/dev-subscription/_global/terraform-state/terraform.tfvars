terragrunt = {
  terraform {
    source = "git::git@github.com:artnetworldwide/terraform-modules.git//modules/azure/terraform_state?ref=master"
  }
}

# storage account name has to be global in Azure
storage_account_name = "artnetdevtfstate"

tags = {
  project = "DevOps"
  owner   = "sryabkov"
}
