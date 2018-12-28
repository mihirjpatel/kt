# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

This repo is following the git-flow convention. Please see [Git Workflows](https://artnet.atlassian.net/wiki/spaces/BP/pages/471105537/Git+Workflows) for more information.

WARNING: branches in this repo are referenced from the [infrastructure-live](https://github.com/artnetworldwide/infrastructure-live) repo. Do not delete any branch in this repo (e.g after the PR is merged) unless you are sure there are no active references to this branch in `infrastructure-live`.

## [3.3.3] - 2018-10-24

### Changed

- `gcp/modules/shared-core/main.tf` create a dedicated service account for Google Tag Manager


## [3.3.2] - 2018-10-02

### Changed

- `gcp/modules/gke-k8s/main.tf` create service account keys after creating service accounts, set up logging and monitoring, istio and pointing deployment to the new cluster
- `gcp/modules/shared-core/main.tf` create storage admin service accounts and keys and update deployment processes to be aware of a new shared core project

### Added

- `shared_scripts/set_circleci_env_variable.py` helper script for setting CircleCI environment variables
- `gcp/modules/shared-core/register_new_shared_core.sh` points current CircleCI deployment processes to the new shared core project resources/buckets
- `gcp/modules/gke-k8s/register_new_k8s.sh` points current CircleCI deployment processes to the new cluster
- `gcp/modules/gke-k8s/helm-service-account.yaml` a yaml file required for helm/tiller installation
- `gcp/modules/gke-k8s/configure_k8s.sh` add a script that runs after a cluster is provisioned to install Helm, Istio, Cluster secrets and Tiller


## [3.3.1] - 2018-09-18

### Changed

- Hotfix to `gcp/modules/shared-vpc`. Restore `shared_vpc_network_name` Terraform output variable. The `gcp/modules/gke-k8s` module relies on the value of this var to place the k8s cluster into the correct VPC.

## [3.3.0] - 2018-09-18

### Added

- `sonicwall/modules/gcp-vpn-tunnel` to configure a VPN tunnel for Google Cloud on the SonicWall device. See README.md in the module for more details

### Changed

- Allow subnet configurations `gcp/modules/shared-vpc` that don't have secondary IP ranges. Previously, they were required. Two secondary IP ranges for each primary IP range are needed for Kubernetes clusters, but they are not needed for spinning up a few VMs. This was done to support the Atlassian project that the SRE/Ops team is working on.

## [3.2.1] - 2018-09-10

### Changed

- Mistakenly not added variable to `variables.tf` due to untested code

## [3.2.0] - 2018-09-10

### Added

- Create a service account for deployment to Kubernetes cluster and grant it permisssions in `gcp/modules/gke-k8s`
- Set permissions on the helm repo bucket in `gcp/modules/shared-core`

## [3.1.0] - 2018-09-10

### Added

- definitions for helm and static artifact repos to `gcp/modules/shared-core`.
- definitions for static storage, storage account and permissions to `gcp/modules/gke-k8s`.

## [3.0.0] - 2018-09-07

This is a version that was used to create infrastructure for the galleries profile release on 2018-08-22.

This is the first release for the Google Cloud infrastructure

### Added

- module `gcp/shared-core`. Contains TF definitions for the DNS zone
- module `gcp/shared-vpc`. Contains TF definitions for Google Cloud VPC, VPN gateway, VPN tunnel, cloud router, etc.
- module `gcp/gke-k8s`. Contains TF definitions for the GKE Kubernetes cluster

## [2.0.0] - 2018-07-18

> **WARNING: BREAKING CHANGES**

### Added

- Module `azure/modules/aks-k8s`. See module [README.md](azure/modules/aks-k8s/README.md) for more info.
- CHANGELOG.md

### Changed

- Reorganize the structure of the repo to support multiple clouds, add placeholders directories for AWS and tests for Azure modules
- For all modules, replace backend configuration with a placeholder to be filled by [Terragrunt](https://github.com/gruntwork-io/terragrunt).
- Slightly refactor module `azure/modules/terraform_state` and add README.md
- Change the structure of the tags to be added to Azure cloud resources and introduce tag schema version
- Revamp the `vnet` module:
  - Use `azurerm` resources to create the vnet gateway and the VPN connection instead of the `null_resource` provisioner. These resources were not available earlier, that's why `null_resource` provisioner had to be used.
  - Reduce the number of variables passed to the module
  - Add subnet for the Kubernetes cluster. Change some var names for consistency.
  - Significantly revise README.md for the module
- Update root-level README.md.

## [1.1] - 2017-11-28

### Changed

- Edit README, edit/add comments. No code changes.

## [1.0] - 2017-11-27

Original release

### Added

- Module `vnet`, a Terraform module to create a virtual network in Azure with optional VPN connection to the office.
- Module `terraform_state`, a Terraform module to keep shared state for resources created in Azure.
