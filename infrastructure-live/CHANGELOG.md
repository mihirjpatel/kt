# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)

This project track live infrastructure changes, so it does NOT adhere to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

Dates in `YYYY-MM-DD` format will be used as release numbers. If there are several releases in a day, the release number for the second release will be `YYYY-MM-DD #2`, the release number for the third release will be `YYYY-MM-DD #3`, etc.

See [README.md] for other important information about this repository.

## [Unreleased]

> **WARNING: BREAKING CHANGES**

### Added

- CHANGELOG.md
- README files
- Variable definition for `gtm_service_account`, which is the label for a service account dedicated to controlling Google Tag Manager.

### Changed

- Restructure for [Terragrunt], which is used as a wrapper for Terraform for all Terraform infrastructure provisioning.
- Reorganize the structure of the repo to support multiple cloud providers. The directory hierarchy is explained in [README.md].
- A single storage account/container per Azure subscription is now used to keep Terraform state. Each module's state is stored under a separate key. The name of the key mirrors the directory structure, so if the directory structure changes, the key will need to be manually changed in the Azure storage container.
- Update [README.md], include information about repo structure and pre-requisites.

### Removed

- git submodules, which were used to bring in Terraform modules from [terraform-modules]
- the `archive` directory, which contained some very early non-Terraform scripts to provision infrastructure
- `adhoc/k8s-azure/New-KubernetesCluster.ps1`, Anton's PowerShell script to provision a Kubernetes cluster in Azure (moved to the [cicd-tools] repo)
- the `.idea` directory used by IntelliJ IDEA. It should have never been committed in the first place
- modules from `environments` that were replaced by Terragrunt and .tfvars files.

### Deprecated

- modules in the `environments` directory that were NOT YET replaced by Terragrunt and .tfvars files. These modules are used to create the azure.artnet.com DNS zone, Azure Key Vault and Service Fabric. As of right now, these modules will likely NOT work, but we don't want to remove them as we definitely need to convert the DNS module and possibly the Azure Key Vault and the Service Fabric ones. This would require changes to [terraform-modules].

## [1.1] - 2017-11-28

Original release of the "executable" Terraform repository with code to create virtual network in Azure with optional VPN connection to the office as well as code to create supporting infrastructure (terraform state storage artifacts and DNS). Modules kept in [terraform-modules] are referenced through git submodules.

[README.md]: README.md
[Terragrunt]: https://github.com/gruntwork-io/terragrunt
[terraform-modules]: https://github.com/artnetworldwide/terraform-modules
[cicd-tools]: https://github.com/artnetworldwide/cicd-tools