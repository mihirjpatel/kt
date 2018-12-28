> Warning: the following is rough documentation to be refined at a later point in time.

> The starting working path is assumed to be `/environments/green/sf`. 

# Overview

This folder contains code and instructions to create a Service Fabric cluster.

The SF cluster:
- is secured by *.azure.artnet.com wildcard certificate
- is behind an internal load balancer (not accessible from the public Internet)
- is set up so SF admins authenticate against Azure AD

> Note: Azure portal requires port 19080 to be open to report management information about the cluster, which is NOT the case for the cluster created according to the code and the instructions in this folder. So, Azure portal won't show all the management information. For more info, please see https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-patterns-networking.

The set up process is described in https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-cluster-creation-via-arm. 

# Initial setup 

## Pre-requisites

Before you run the installation, you need to have the following in place:
- vnet-green virtual network with the subnets and the VPN tunnel. See `/environments/readme.md` and `/environments/green/vnet` in this repo.
- *.azure.artnet.com certificate. See `README.md` in the `DevOpsPrivate` repo (warning: limited access, see Matt C. or Sergei R.)
- Azure Key Vault (see `/environments/green/vnet/key-vault` in this repo)
- The *.azure.artnet.com certificate pre-loaded into the Azure Key Vault. See `/environments/green/vnet/key-vault` in this repo.
- Azure AD 
- Two applications created in the Azure AD. See below.


### Create two applications for the SF cluster in the Azure AD

This is for authenticating users performing management operations on the SF cluster.

Article: [Create a Service Fabric cluster by using Azure Resource Manager, section 'Set up Azure Active Directory for client authentication'](https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-cluster-creation-via-arm#set-up-azure-active-directory-for-client-authentication)


Run in a PowerShell Console:

```
cd aad\AADTool

$subscriptionId = '08346c6c-bd12-45ad-8717-ba1c28f94648'
$tenantId = 'f99ef0be-7868-495e-b90c-12dee38c1fdc'
$clusterName = 'sf01'
$replyUrl = "https://${clusterName}.azure.artnet.com:19080/Explorer/index.html"

Login-AzureRmAccount

Set-AzureRmContext -SubscriptionId $subscriptionId

.\SetupApplications.ps1 -TenantId $tenantId -ClusterName $clusterName -WebApplicationReplyUrl $replyUrl 

```

#### Assign users to roles

https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-cluster-creation-via-arm#assign-users-to-roles

The process requires the use of Azure Classic Portal, which requires the person to be a subscription administrator. Azure Classic Portal will cease to exist on Jan 8, 2018.

On 12/12/17, Sergei posted the following comment on https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-cluster-creation-via-arm 

@linggeng@MSFT @ChackDan[MSFT] According to the messages on the Azure Classic Portal, it is being retired on Jan 8, 2018, less than a month from now, and after that (again, according to the messages on the portal) all Azure AD administration will have to be done through the new portal. I could not find a way to assign AAD users to SF Admin/ReadOnly roles in the new portal. Is there another (new) UI for that? 
Related, can the AAD helper scripts (http://servicefabricsdkstorage.blob.core.windows.net/publicrelease/MicrosoftAzureServiceFabric-AADHelpers.zip) be moved to a Github repo vs. being a downloadable zip file? If the scripts are in the repo, someone from the community could create a script to assign AAD users to SF Admin/ReadOnly roles and open a pull request. Such a script could be based on the existing SetupUser.ps1. 


## Initial Setup Commands

> All commands are Azure CLI 2.0 commands

Navigate to the directory that has the Azure Resource Manager template and parameter files:
```
cd arm\windows
```

Log in to Azure:
```
az login
```

Create a resource group for the SF cluster:
```
az group create --name rg-sf01 --location eastus
```

Validate the ARM template:
```
az group deployment validate --resource-group rg-sf01 --template-file template.json --parameters parameters.json
```

Deploy the ARM template:
```
az group deployment create --name sf01_01 --resource-group rg-sf01 --template-file template.json --parameters parameters.json
```

## Clean up

To delete the cluster, delete the resource group:
```
az group delete --name rg-sf01
```

# Daily Creation and Destruction

The montly bill for five SF nodes can easily reach $500. We want to be able to shut down the SF when we don't need it (e.g. overnight and over the weekends), but Service Fabric has not been designed to be shut down and start up (e.g. see https://stackoverflow.com/questions/39640787/turning-off-servicefabric-clusters-overnight).

We can drop and re-create the SF cluster as we need. 

To destroy the SF cluster, delete the resource group:
```
az group delete --name rg-sf01
```

To re-create the SF cluster, you can run the following commands:
```
az group create --name rg-sf01 --location eastus
az group deployment create --name sf01_01 --resource-group rg-sf01 --template-file template.json --parameters parameters.json
```