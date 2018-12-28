> WARNING: This folder and its subfolders needs to be "Terragrunted", and the rest of the README needs to be reviewed. Do not use this folder until these activities have been done.

# Overview

[Terraform](https://www.terraform.io/) is the agreed-upon way of handling infrastructure at Artnet. 

All of code written so far (up to 2017-11-27) uses [Terraform Azure provider](https://www.terraform.io/docs/providers/azurerm/index.html) to create infrastructure resources in Azure. However, other providers, such as [WMware vSphere provider](https://www.terraform.io/docs/providers/vsphere/index.html) are available and might be used in future.

Each folder with Terraform (*.tf) files is called a module. 

This readme file contains a high-level overview of various Terraform modules, their purpose, and how they are related to each other. For instructions on executing specific modules, please refer to readme files in each module. 

There are three subfolders in the `terraform` folder:
- `global`
- `blue`
- `green`


# Global Environment

The `global` folder contains Terraform modules that define infrastructure resources that are global in nature and are shared among different environments (such as dev, uat, prod, blue, green, etc - see more on Environments below). You typically would not drop and re-create such resources, although you can, if only to test or retest the Terraform modules that define them. If you were re-creating the whole infrastructure from scratch, you would create the `global` resources using the `global` Terraform modules first. An example of one such resource is Artnet's DNS zone `azure.artnet.com`.


# Blue/Green Environments

One of the reasons we are pursuing infrastructure as code is to make environments or at least large parts of the environments createable/destroyable on the fly. So, we want to be able to provision and destroy environments as we please. The `blue` and `green` folders contain code for creating two environments. We call them `blue` and `green` for a couple of different reasons:

- To emphasize that environments are ephemeral: the whole environment or a large portion of it can have a life span measured in minutes, hours or days, not months or years. Giving an environment a more traditional label (such as `dev`, `staging` or `prod`) can make people believe that the environments are more permanent.

- To empasize that environments are structurally identical: there is no difference between a `dev` and a `prod` environment but the configuration and permissions. Note: this might only be partially true if the hosting facilities are different and there might be differences related to `blue` being a higher (or lower) version than `green`. 

- To hint at the fact that `blue` and `green` can be used in the _blue/green deployment_ meaning, where if your production infrastructure runs in the `blue` environment, we can build a parallel `green` environment, which has (potentially) newer version of infrastructure and newer version of application code, test the `green` environment, cut over our production workload from `blue` to `green`, make sure that things are stable and then destroy the `blue` enviornment. Next release, we can repeat the same process now using `green` as the current production environment and `blue` as the new verision. See https://martinfowler.com/bliki/BlueGreenDeployment.html for another explanation. 

> The `global`, `blue` and `green` folders are Terraform root modules. [Root modules](https://www.terraform.io/docs/modules/create.html) are modules where you run `terraform apply`. Root modules can reference other, shared, modules, which is a form of code reuse in Terraform. You can think of a shared Terraform module as a library in a traditional programming language. Root level module contains only reference(s) to the shared 'library' module and the parameter values that are passed to it. Modules in the `blue` and `green` subfolders are examples of such modules. They reference modules that are stored in a separate git repository. The same module under `blue` and `green` subfolders can 
reference different versions of the shared 'library' module. Shared 'library' modules are stored as git submodules.

So, instead of careating tradional dev, staging, and production environments, we have two folders: one for the `blue` environment and the other one is for `green`. 


# Getting up-to-speed on Terraform

- A good Terraform tutorial: [Terraform: Up and Running](https://www.amazon.com/Terraform-Running-Writing-Infrastructure-Code/dp/1491977086) by Yevgeniy Brikman 

> Also [available on SafariBooksOnline](https://www.safaribooksonline.com/library/view/terraform-up-and/9781491977071/) 

> A slightly outdated but free version of the book is available as [a series of blog posts](https://blog.gruntwork.io/a-comprehensive-guide-to-terraform-b3d32832baca)

- Pluralsight's [Terraform - Getting Started](https://app.pluralsight.com/library/courses/terraform-getting-started) course on Terraform (subscription required)

> The author of this readme didn't watch it, but it has good reviews

- [Terraform documentation](https://www.terraform.io/docs/)
- [Terraform Azure provider documentation](https://www.terraform.io/docs/providers/azurerm/index.html)


# How to create the infrastructure using Terraform

## Summary of pre-requisites

- Access to [Azure Portal](https://portal.azure.com), Artnet Azure subscription and [Azure Cloud Shell](https://azure.microsoft.com/en-us/features/cloud-shell/).
- At the moment, full access (admin access) to the subscription is assumed, although much fewer permissions are needed.
- Access to Artnet's Visual Studio Team Services instance artnetworldwide.visualstudio.com, which has repos with infrastructure code.
- [VSTS personal access token](https://docs.microsoft.com/en-us/vsts/accounts/use-personal-access-tokens-to-authenticate) so that you can authenticate against VSTS from git command-line client.
- Access to Bash shell and required software
- Some environment variable settings (described below)

## Steps to provision infrastructure for the `blue` or `green` environment using Azure Cloud Shell

> We are making an assumption that the infrastructure for the `global` environment has already been provisioned.

> The steps below assume you are using [Azure Cloud Shell](https://azure.microsoft.com/en-us/features/cloud-shell/). Some differences when executing from a local machine are described below.

### Launch Azure Cloud Shell

Open [Azure Portal](https://portal.azure.com) and launch [Azure Cloud Shell](https://azure.microsoft.com/en-us/features/cloud-shell/). Use Bash. Remember, Bash is case-sensitive.

### Choose the Azure subscription

```
    az account set --subscription 08346c6c-bd12-45ad-8717-ba1c28f94648
```

> The subscription number above is Artnet's Trial/Pay-As-You-Go subscription. This step is needed if you are using more than one subscription (e.g. your Visual Studio Azure subscription and Artnet's Trial/Pay-As-You-Go subscription).

> This step needs to be re-run if you restart Azure Cloud Shell.

### Clone the infrastructure code

Clone the infrastructure code. Authenticate using [VSTS personal access token](https://docs.microsoft.com/en-us/vsts/accounts/use-personal-access-tokens-to-authenticate)

```
    git clone --recursive https://artnetworldwide.visualstudio.com/_git/DevOps
```

> This steps DOES NOT need to be re-run every time you restart Azure Cloud Shell because the content of your home folder is persisted across sessions.

### Set user name environment variable

Resources created by Terraform are tagged for tracking and cost management reasons, so Terraform needs to know the identity of the user/process that provisions the infrastructure. You can set an environment variable that would prevent Terraform from asking you who you are:
```
    #replace with your email address, e.g. 
    #export TF_VAR_user_running_terraform=sRyabkov@artnet.com
    export $TF_VAR_user_running_terraform=jsmith@artnet.com 
```
> If you don't set this environment variable, Terraform will prompt you for this information.

> This step needs to be re-run if you restart Azure Cloud Shell.

### Pick the environment

 Pick the environment (`blue` and `green`) folder and stick with it for the remainder of this file. Remember, names are case-sensitive. 

```
    cd /DevOps/code/terraform/blue  
    #OR
    #cd /DevOps/code/terraform/green
```

### Create/verify shared Terraform state for the environment

Create/verify `terraform_state` exists and is initialized. This module creates shared Terraform state, which allows different developers/Ops engineers to share the state of the environment. Terraform uses state to track which resources already exist. By default, state is stored in a local folder, but we need shared lockable state for collaboration. The `terraform_state` module creates a storage account and a storage container for the shared state in Azure. Please notice that `blue` and `green` use different storage accounts. 

    cd /DevOps/code/terraform/blue  # OR cd /DevOps/code/terraform/green
    cd terraform_state/
    terraform init
    terraform plan
    terraform apply

> This step does only needs to be run once and it only needs to be re-run if the storage account gets deleted. 

### Set the environment variable with access key to the shared state

For Terraform to be able to access shared Terraform state, you need to create an environment variable that contains access key for the appropriate storage account. As a reminder, `blue` and `green` use different storage accounts. To find the key, open [Azure Portal](https://portal.azure.com), navigate to 'Storage Accounts', find the right account (the account name would end in either `blue` or `green`), click on 'Access Keys' and copy one of the keys (key1 or key2). Make sure to copy the value from the KEY column, not from the CONNECTION STRING column. Then run the following command

```
    export ARM_ACCESS_KEY=paste_the_value_you_copied 
    # e.g. 
    # export ARM_ACCESS_KEY=6Yln1xSKjYT4jC4wzNTYoTWJEMnNT3oY6LGeL6hSuZFar7dMY7es0JfJZvAebQ2PBhnwZhJjSJQPpzOajXTXjg== 
    #not a real value
```
> Important: do not mix up keys. Use the key for the `blue` storage account to work with the `blue` environment and the key for the `green` storage account to work with the `green` environment. 

> This step needs to be re-run every time you restart Azure Cloud Shell.

### Update Terraform 

Azure Cloud Shell has Terraform preinstalled, but it currently has the older version (0.10) installed. We need v.0.11

```
mkdir ~/bin
curl https://releases.hashicorp.com/terraform/0.11.0/terraform_0.11.0_linux_amd64.zip?_ga=2.267086158.1767819861.1511793121-241776507.1508118531 \
  --output ~/bin/terraform.zip
unzip ~/bin/terraform.zip -d ~/bin/
rm ~/bin/terraform.zip
```

> This steps DOES NOT need to be re-run every time you restart Azure Cloud Shell because the content of your home folder is persisted across sessions.

### Create a Bash alias for the correct version of Terraform

Create an alias for terraform so that when run `terraform`, the correct version of terraform gets executed

```
    alias terraform='~/bin/terraform'
```

> This step needs to be re-run every time you restart Azure Cloud Shell.

### Create virtual network 

Create a virtual network in Azure and the VPN tunnel between the virtual network and the office network.
The network can be created in different ways:
- without connectivity to the office (fast)
- with VPN tunnel connectivity to the office (can take up to 45 min)

The following two variables control which configuration gets created: `include_gateways_for_vpn_tunnel` and `include_vpn_connection`. If they are set to 1, both the network and the VPN tunnel to the office will be created.

If `include_gateways_for_vpn_tunnel` and `include_vpn_connection` are set to 0, the following resources will be created/updated/destroyed (depending on the Terraform command and the current state): 
- the resource group, 
- the virtual network, 
- the security group, 
- and the user-defined subnets. 

If `include_gateways_for_vpn_tunnel` or `include_vpn_connection` are set to 1, in addition to the above, the following other resources will be created:
- the GatewaySubnet, 
- the local network gateway (which represents the VPN device in the office), 
- the vnet gateway, 
- the public IP address for the vnet gateway, 
- and the DNS entry for the publich IP address. 

If `include_vpn_connection` is set to 1, the VPN connection between the local and the vnet gateway are created, otherwise the VPN connection itself doesn't get created, but all the pre-requisite resources will be in place.

> Once you chose the value of the variable, you should continue using it for subsequent executions. For example, if you run `terraform apply` with `include_gateways_for_vpn_tunnel` and `include_vpn_connection` set to 1, you should run future `terraform apply` or `terraform destroy` with `include_gateways_for_vpn_tunnel` and `include_vpn_connection` set to 1 as well, otherwise you might get errors, because if you run `terraform destroy` with `include_gateways_for_vpn_tunnel` or `include_vpn_connection` set to 0, Terraform will skip these resources, but when it will try to destroy the virtual network or the resource group, these operations will fail because other resources (the local or the vnet gateway), which were filtered out by using `include_gateways_for_vpn_tunnel` or `include_vpn_connection` set to 0, depend on them.

> An external module is used to create the virtual network. Please see the readme file in that [external modules repo](https://artnetworldwide.visualstudio.com/DevOps/_git/terraform_modules) for information on how this module was put together and for the links on background information about Azure networking. 

Run the following command before you run `terraform apply` with `include_vpn_connection` set to 1 to make sure the secret key for the VPN tunnel has been set:
```
    echo $SHARED_IPSEC_KEY
```

Then run:
```
    cd /DevOps/code/terraform/blue  
    #OR cd /DevOps/code/terraform/green
    cd vnet/
    terraform init
    terraform plan 
    terraform apply
```

> Enter `1` for `var.include_gateways_for_vpn_tunnel` and `1` for `var.include_vpn_connection`.

> Terraform shows you what it is going to do. If terraform shows that it needs to create `null_resource.vnet_gateway`, applying terraform configuration can take up to 45 min.


- `SHARED_IPSEC_KEY` environment variable should be set and it should contain the shared secret key for creating the VPN channel. This key is used when configuring the on-premise VPN device.

## Optional info on how to run the scripts from a local computer  

### Bash shell

You can use Terminal in MacOS, [bash shell in Windows 10](https://www.windowscentral.com/how-install-bash-shell-command-line-windows-10), 
or git bash.

> Testing was done using Terminal on a Mac and Azure Cloud Shell. It should be possible to use Windows, but it was not tested.

## Azure CLI

Azure CLI needs to be installed if you are using a local computer. See the instructions at https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest.

## Terraform

You need to have Terraform installed. To see if you have it installed, open the terminal/console/command prompt and run
```
    terraform -version
```
You need at least version `0.11`

Terraform is a single executable and can be downloaded from [Download Terraform](https://www.terraform.io/downloads.html).

If you are using [Homebrew](https://brew.sh/) on a Mac, you can run 
```
    brew install terraform
```

To upgrade Terraform to the latest version (using Homebrew), run
```
    brew upgrade terraform
```


# See Also

See the readme file in the [external modules repo](https://artnetworldwide.visualstudio.com/DevOps/_git/terraform_modules)