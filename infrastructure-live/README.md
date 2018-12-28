# Overview

Artnet currently uses [Terraform] in combination with [Terragrunt] to manage its infrastructure using the Infrastructure-as-code approach. Terragrunt is a thin wrapper around Terraform and is used to avoid/minimize Terraform code duplication.

Terraform modules are maintained in the [terraform-modules] repository. Those modules are templates describing how infrastructure primitives should be combined to create a single logical infrastructure resource such as a VPC or a Kubernetes cluster. Terraform-modules in the [terraform-modules] repository are analogous to libraries in application development, where libraries are not executed by themselves but rather linked into programs. One library can be used by multiple programs, and different programs can use different version of the library. Similarly to application development, modules in the [terraform-modules] repo are never executed directly. Instead, they are executed from this repository.

Each Terraform module typically defines a set of variables that need to be initialized before the module can do its work. Each `resource` directory in the [infrastructure-live] repository (this repo) contains a reference to a particular version of a particular Terraform module and provides values for the variables required by this Terraform module. Each Terraform module referenced in this repo is located in either the [terraform-modules] repo or some other Terraform module repository. Please see [Module Sources] in Terraform documentation for a list of sources supported by Terraform/Terragrunt.

## Repository organization

### Hierarchy

The hierarchical structure of this repository is as follows:

```
cloud-provider
    cloud-provider-security-and-billing-boundary
        environment
            resource
```

#### cloud-provider

`cloud-provider` should be `aws` for Amazon Web Services, `azure` for Microsoft's Azure or `gcp` for Google Cloud Platform.

#### cloud-provider-security-and-billing-boundary

`cloud-provider-security-and-billing-boundary` refers to an entity within a particular cloud provider that is used as a security and billing boundary. AWS uses accounts, Azure uses subscriptions, and GCP uses projects for this purpose. `cloud-provider-security-and-billing-boundary` should contain declarations to define resources maintained in a particular AWS account, Azure subscription or GCP project. For example, `azure/dev-subscription` contains definitions for resources located in the `Artnet - Development` subscription.

> WARNING: Production resources must be maintained in separate AWS account(s), Azure subscription(s) or GCP project(s). These accounts/subscriptions/projects must be designated as "production".

#### environment

`environment` contains a set of logically grouped `resource`s that typically have dependencies on each other and that should be isolated from other environments. An example could be a Kubernetes cluster located in a particular virtual network.

> NOTE: `_global` is a special environment name that should be used for singletons, i.e. resources that can/should only be provisioned once per `cloud-provider-security-and-billing-boundary` and on which resources in other, "regular" environments depend.

A new environment can be created by copying/pasting an existing `environment` directory and modifying it.

> WARNING: __be VERY CAREFUL with copying/pasting `environment` directories__. `Environment` directories typically contain several files that set variable values that are passed to Terraform modules. Some of the files can be located in the `environment` directory itself while others are located in the `resource` subdirectories. Failure to change some of the variable values can lead to problems with not only provisioning the new environment but also to potentially breaking an existing working environment that was used as a source in the copy/paste operation.

#### resource

Each `resource` directory contains a reference to a particular version of a particular Terraform module and provides values for the variables required by this Terraform module. Each Terraform module provisions/de-provisions a set of related infrastructure resources that are designed to be provisioned/destroyed together.

There are usually several `resource` directories in each `environment` directory. If one `resource` depends on other resources in the same environment, these dependencies should be declared as descried in [dependencies-between-modules] in Terragrunt documentation.

> IMPORTANT: resources defined in one environments SHOULD NOT have dependencies on resources defined in another environment with a possible exception of the special `_global` environment. If dependencies on other environments cannot be avoided, the dependencies MUST be clearly documented in README.md located in the `environment` and/or the `resource` directory. This includes dependencies on the special `_global` environment.

### Branches

This repository does NOT follow the git-flow convention. Instead it follows the Feature Branch Workflow (aka GitHub Flow), i.e. the single master branch + feature branches setup. Please see [Git Workflows] for more information.

## How to provision/de-provision infrastructure

> WARNING: the steps below were written for Mac OS. Everything should work on Linux and Windows, but testing was only done on a Mac.

### Pre-requisites

- __YOU MUST KNOW/UNDERSTAND [Terraform] and [Terragrunt]__.
  - See [Resources for learning Terraform].
  - Carefully study the long README in the [Terragrunt] GitHub repo to learn Terragrunt.
- At least read-only access to [infrastructure-live] and [terraform-modules] GitHub repositories _using SSH_.
- Appropriate permissions to create infrastructure resource on the `cloud-provider-security-and-billing-boundary` level.
- [Terraform] is installed and is in PATH
- [Terragrunt] is installed and is in PATH

> WARNING: The first set of resources that should be provisioned is `terraform-state`. Terraform state is maintained on the `cloud-provider-security-and-billing-boundary` level.

### Azure requirements

- [Azure CLI] is installed and is in PATH.
- The environment variables below are setup (for more info, see [Configure Terraform environment variables]):
  - `ARM_SUBSCRIPTION_ID` (Azure subscription ID)
    - `Artnet - Development`: 08346c6c-bd12-45ad-8717-ba1c28f94648
    - `Artnet - Production`: 9a6ba5ec-c7b3-4f6c-b74a-416cc83045bc
  - `ARM_CLIENT_ID` (ID of the Azure AD service principal used by Terraform)
    - For `Artnet - Development` subscription, `AZ_DEV_USER_RW` can be used (search Confluence for `AZ_DEV_USER_RW` for more info)
  - `ARM_CLIENT_SECRET` (password for the Azure AD service principal used by Terraform)
    - For `Artnet - Development` subscription, search Confluence for `AZ_DEV_PASSWORD_RW`
  - `ARM_TENANT_ID` (ID of Artnet's Azure AD)
    - Use `f99ef0be-7868-495e-b90c-12dee38c1fdc` for both `Artnet - Development` and `Artnet - Production` subscriptions.
  - `ARM_ENVIRONMENT` (`public` for main Azure cloud, other options are `usgovernment`, `german`, `china`)
    - This variable needs to be set up only if the value is not `public`

### Provisioning Steps

We don't yet have the CI/CD pipeline for infrastructure code, so infrastructure is provisioned by executing Terragrunt from a local machine. Clone the [infrastructure-live] repo and navigate to the correct directory.

#### Provisioning a `resource`

- Open Terminal in the `resource` directory
- Run `terragrunt plan`, review the plan.
- Run `terragrunt apply`, review the plan, confirm provisioning.

#### De-provisioning a `resource`

- Open Terminal in the `resource` directory
- Run `terragrunt destroy`, review the plan, confirm de-provisioning.

#### Provisioning an `environment` (all `resource`s in an `environment`)

- Open Terminal in the `environment` directory
- Run `terragrunt apply-all`. Confirm, when prompted.

#### De-provisioning an `environment` (all `resource`s in an `environment`)

- Open Terminal in the `environment` directory
- Run `terragrunt destroy-all`. Confirm, when prompted.

## Documentation and help

There are few or no README files in the `resource` directories in this repo explaining how to use the modules. This is to avoid repetition. Oftentimes, there are several environments that reference the same modules and differ only in the values for the variables (e.g. `azure/dev-subscription/blue/aks-k8s` and `azure/dev-subscription/green/aks-k8s`. Placing README files in these directories would not be [DRY].

To find documentation for the module, find the referenced module in the `terraform.tfvars` file and look at this location for help. The reference would look like

    terragrunt = {
      terraform {
        source = "git::git@github.com:artnetworldwide/terraform-modules.git//azure/modules/aks-k8s?ref=master"
    ...

In the example above, look for a README file in the [terraform-modules] GitHub repository, in the `develop` branch, in the `azure/modules/aks-k8s` folder starting from the root. Instead of the branch, other git `refs` could be used, such as tags.

> The double slash is intentional. See README in [Terragrunt] GitHub repo for more info.

If a README file does exist in this repo, it would be very brief and it would only be used to list important information for _this particular instance of infrastructure resources_.

## Changelog

Please see [CHANGELOG.md](CHANGELOG.md)

[Terraform]: https://www.terraform.io/
[Terragrunt]: https://github.com/gruntwork-io/terragrunt/
[infrastructure-live]: https://github.com/artnetworldwide/infrastructure-live
[terraform-modules]: https://github.com/artnetworldwide/terraform-modules
[Module Sources]: https://www.terraform.io/docs/modules/sources.html
[dependencies-between-modules]: https://github.com/gruntwork-io/terragrunt/blob/master/README.md#dependencies-between-modules
[Git Workflows]: https://artnet.atlassian.net/wiki/spaces/BP/pages/471105537/Git+Workflows
[Resources for learning Terraform]: https://artnet.atlassian.net/wiki/spaces/BP/pages/303366151/Terraform
[Azure CLI]: https://docs.microsoft.com/en-us/cli/azure/?view=azure-cli-latest
[Configure Terraform environment variables]: https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure#configure-terraform-environment-variables
[DRY]: https://en.wikipedia.org/wiki/Don%27t_repeat_yourself
[CHANGELOG.md]: CHANGELOG.md