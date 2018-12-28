# terraform-modules

## Overview

Artnet currently uses [Terraform] in combination with [Terragrunt] to manage its infrastructure using the Infrastructure-as-code approach. Terragrunt is a thin wrapper around Terraform and is used to avoid/minimize Terraform code duplication.

This repo contains reusable Terraform modules. These modules are templates describing how infrastructure primitives should be combined to create a single logical infrastructure resource such as a virtual network or a Kubernetes cluster. The modules in this repo are not executed directly. They are referenced in the [infrastructure-live] repo and are executed from there.

> NOTE: For a more detailed explanation of how [infrastructure-live] and [terraform-modules] repositories work together, please see the root-level `README.md` in the [infrastructure-live] repository.

The `tests` directory is a placeholder for now.

## Changelog

Please see [CHANGELOG.md](CHANGELOG.md)

[Terraform]: https://www.terraform.io/
[Terragrunt]: https://github.com/gruntwork-io/terragrunt/
[infrastructure-live]: https://github.com/artnetworldwide/infrastructure-live
[terraform-modules]: https://github.com/artnetworldwide/terraform-modules
