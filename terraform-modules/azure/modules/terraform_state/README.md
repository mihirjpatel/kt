# terraform-state

## Overview

This module creates an Azure storage account and container to be used for storing [lockable Terraform remote state](https://www.terraform.io/docs/backends/types/azurerm.html).

This module is a pre-requisite for all other modules.

One storage account and container are created in `infrastructure-live` per Azure subscription (currently, one for `Artnet - Development` subscription and one for `Artnet - Production` subscription) but a separate remote state file is created for each Terragrunt/Terraform module (directory) in `infrastructure-live`. The key to store/retrieve Terraform state for a particular module mirrors the directory structure in the `infrastructure-live` repo.

## Parameters

See `variables.tf`

## How to use

This module is not used directly. Instead it is used by Terragrunt/Terraform code stored in the `infrastructure-live` repository. For an explanation of how `infrastructure-live` and `terraform-modules` repositories work together, please see the root-level README.md in the `infrastructure-live` repository.
