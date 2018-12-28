# vnet Terraform module

## Overview

For an overview of this repository, please see `README.md` in the root of the repository.

This Terraform module is used to create a virtual network in Azure.

The network can be created in two different ways:

- without site-to-site VPN tunnel to the office (fast)
- with site-to-site VPN tunnel to the office (can take up to 45 min)

## Background information

The overall process of setting up a virtual network in Azure and the site-to-site VPN connection between the on-premises and the Azure
virtual network is described in [Create a Site-to-Site connection in the Azure portal].

## Relevant Azure documentation

- [Virtual Networks]
- [VPN gateway]
- [Azure CLI]

## Manual one-time setup on the on-prem side

One-time setup is required on the on-prem VPN device (Dell Sonic Wall NSA 4600). As of July 2018, the on-prem VPN device had two VPN tunnels setup: one for the `blue` environment and the other one for the `green` environment.

SonicWall configuration guide is available at [How do I configure a VPN between a SonicWall firewall and Microsoft Azure?]

The required configuration values for the on-prem device:

| Environment | IPsec Primary Gateway Name        | Shared Secret                           | Network     | Netmask       |
| ----------- | --------------------------------- | --------------------------------------- | ----------- | ------------- |
| `green`     | vpngateway-green.azure.artnet.com | `AZURE_VPN_TUNNEL_SHARED_IPSEC_KEY_DEV` | `10.20.0.0` | `255.255.0.0` |
| `blue`      | vpngateway-blue.azure.artnet.com  | `AZURE_VPN_TUNNEL_SHARED_IPSEC_KEY_DEV` | `10.21.0.0` | `255.255.0.0` |

> NOTE: `AZURE_VPN_TUNNEL_SHARED_IPSEC_KEY_DEV` is stored in 1Password's DevOps vault. See [DevOps Secrets Vault in 1Password] for more information.

## Module Inputs

### Module variables

Most input variables are documented in `variables.tf`

The following two variables control which network configuration gets created: `include_gateways_for_vpn_tunnel` and `include_vpn_connection`. If these two variables are set to `1`, both the network and the VPN tunnel to the office will be created.

> NOTE: `include_gateways_for_vpn_tunnel` and  `include_vpn_connection` are separate variables primarily to simplify module development and debugging.
During normal use, both of these variable will have the same value (BOTH of them will be either `0` or `1`)

If `include_gateways_for_vpn_tunnel` and `include_vpn_connection` are set to `0`, the following resources will be created/updated/destroyed:
- the resource group
- the virtual network
- the user-defined subnets

If `include_gateways_for_vpn_tunnel` OR `include_vpn_connection` are set to `1`, in addition to the above, the following other resources will be created/updated/destroyed:
- the GatewaySubnet (special subnet required by Azure to use with the vnet gateway)
- the local network gateway (which represents the VPN device in the office)
- the vnet gateway
- the public IP address for the vnet gateway
- the DNS entry for the public IP address

If `include_vpn_connection` is set to `1`, the VPN connection between the local and the vnet gateway are created, otherwise the VPN connection itself doesn't get created, but all the pre-requisite resources will be in place.

> IMPORTANT: if `include_gateways_for_vpn_tunnel` and `include_vpn_connection` were set to `1` when the resources were provisioned, they should be set to `1` when the resources need to be destroyed.

### Environment variables

#### `ARM` variables

See the root-level README in the [infrastructure-live] repo for more information.

#### `TF_VAR_vpn_connection_shared_key`

This environment variable should contain the shared secret key for creating the VPN channel between the on-premise VPN device and the vnet gateway created in Azure. It should be set to the value stored in the `AZURE_VPN_TUNNEL_SHARED_IPSEC_KEY_DEV` secret, which is stored in 1Password's DevOps vault. See [DevOps Secrets Vault in 1Password] for more information.

## Important notes

### Custom DNS entries for Azure vpn gateways

The on-prem VPN device needs to know the IP address of the Virtual Network Gateway in Azure to establish the VPN tunnel. But when the Virtual Network Gateway gets dropped and then re-created, it gets assigned a new IP address. To avoid manually re-configuring the on-prem VPN device every time we drop and re-create the Virtual Network Gateway in Azure, we use a DNS name during one-time on-prem VPN device configuration. This DNS name is in the DNS zone (azure.artnet.com) the management of which is delegated to Azure, so we can programmatically, using Terraform, create or update DNS entries in that zone.

### Cost of Virtual Network Gateway

The SKU for the Virtual Network Gateway is hard-coded in this module to control costs and it is currently set to 'Basic'.

Virtual Network Gateway seems to be the most expensive resource in Azure Networking. It is implemented as two VMs (for fault-tolerance) and some networking resources pre-configured in a special way. These resources are used for connectivity between the office and the vnet in Azure, and because of that, a Virtual Network Gateway is not something that should be turned on or off during nights and weekends. It take a long time (up to 45 min) to create a virtual network gateway.

The estimated monthly cost of the 'Basic' SKU is $27. This is currently the cheapest offering.

### Network security groups 

Network security groups are not created and subnets are not associated with security groups in this module. This is on purpose, because network security groups can get in the way.
One example of that is placing an AKS cluster into an existing subnet during cluster creation: the AKS provisioning process creates its own security group and attaches it to AKS nodes NICs. If there is a security group attached to subnet, then changes would need to be done in both the security group that we had created and the one that AKS created to allow traffic to flow in and out.

### Name resolution

Name resolution is NOT handled by this module. Name resolution is automatic within Azure (e.g. a VM in a vnet in Azure
can resolve names of other VMs in the same vnet, but the resources in Azure won't be able to resolve the names of the machines
on-premises and vice versa).

### Manual clean up

The normal way to destroy the resources is to run `terragrunt destroy`. If this doesn't work, and you would like to manually delete all resources, you can do that by deleting the Azure resource group that contains all the networking resources (all created networking resources are located in one Azure resource group). To delete Azure resource group using command-line and Azure CLI, run:

```bash
    az group delete --name <RESOURCE_GROUP_NAME>
```

> NOTE: You can also delete a resource group using [Azure Portal]

After deleting the resource group manually, Terraform's state file will be out of sync with reality, and it needs to be refreshed or manually deleted.

### How to use/run this module

See the root-level `README.md` in the [infrastructure-live] repository

[Terraform]: https://www.terraform.io/
[Terragrunt]: https://github.com/gruntwork-io/terragrunt/
[infrastructure-live]: https://github.com/artnetworldwide/infrastructure-live
[terraform-modules]: https://github.com/artnetworldwide/terraform-modules
[Create a Site-to-Site connection in the Azure portal]: https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-howto-site-to-site-resource-manager-portal
[Virtual Networks]: https://docs.microsoft.com/en-us/azure/virtual-network/
[VPN gateway]: https://docs.microsoft.com/en-us/azure/vpn-gateway/
[Azure CLI]: https://docs.microsoft.com/en-us/cli/azure/overview?view=azure-cli-latest
[How do I configure a VPN between a SonicWall firewall and Microsoft Azure?]: https://www.sonicwall.com/en-us/support/knowledge-base/170505320011694
[DevOps Secrets Vault in 1Password]: https://artnet.atlassian.net/wiki/spaces/BP/pages/702775341/DevOps+Secrets+Vault+in+1Password
[Azure Portal]: https://portal.azure.com
