# aks-k8s

## Overview

For an overview of this repository, please see `README.md` in the root of the repository.

This [Terraform] module creates a Kubernetes (K8s) cluster in Azure using Azure Kubernetes Service (AKS).

This module creates the K8s cluster using [Terraform's null_resource] provisioner, which utilizes [Azure CLI]. It is NOT using the [Terraform's Azure Provider azurerem_kubernetes_cluster resource], because at the time the module was created, the Terraform resource did not provide support for some advanced settings to set up the K8s cluster that we needed.

## Dependencies

This module depends on the existence of a virtual network created by the `vnet` module.

## Parameters

See `variables.tf`

## How to use

See the root-level `README.md` in the [infrastructure-live] repository

[Terraform]: https://www.terraform.io/
[Terraform's null_resource]: https://www.terraform.io/docs/provisioners/null_resource.html
[Azure CLI]: https://docs.microsoft.com/en-us/cli/azure/?view=azure-cli-latest
[Terraform's Azure Provider azurerem_kubernetes_cluster resource]: https://www.terraform.io/docs/providers/azurerm/r/kubernetes_cluster.html
[infrastructure-live]: https://github.com/artnetworldwide/infrastructure-live
