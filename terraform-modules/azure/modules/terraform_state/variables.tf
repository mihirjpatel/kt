variable "resource_group_name" {
  description = "Resource group name for the storage account that will keep Terraform state"
}

variable "storage_account_name" {
  description = "Name of Azure storage account. Has to be unique across Azure"
}

variable "storage_container_name" {
  description = "Name of Azure storage container within the storage account"
}

variable "location" {
  description = "Azure location (useast, useast2, uswest, etc.)"
}

variable "environment" {
  description = "Environment (dev, staging, prod, blue, green, etc.)"
}

variable "tags" {
  type        = "map"
  description = "Tags to associate with the resources"
}
