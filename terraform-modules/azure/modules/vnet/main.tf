terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "azurerm" {}
}

locals {
  vnet_address_space = "${var.vnet_address_space_prefix_x_y}.0.0/16"

  vnet_user_subnet_names = [
    "${var.vnet_k8s_subnet_name}",
  ]

  vnet_user_subnet_address_spaces = [
    "${var.vnet_address_space_prefix_x_y}.8.0/24",
  ]

  vnet_gateway_public_ip_name          = "vnet-gateway-public-ip-${var.environment}"
  vnet_gateway_name                    = "vnet-gateway-${var.environment}"
  default_gateway_subnet_address_space = "${var.vnet_address_space_prefix_x_y}.0.0/24"

  local_network_gateway = {
    name              = "artnet-nyc-office-gateway-${var.environment}"
    public_ip_address = "65.254.28.67"                                 #the IP address of the on-prem VPN device
    local_ip_range    = "192.168.0.0/23"                               #the IP range of the office network
  }

  vpn_connection_name                = "office-vpn-connection-${var.environment}"
  azure_dns_zone                     = "azure.artnet.com"
  azure_dns_zone_resource_group_name = "rg-globals"
  gateway_dns_a_record               = "vpngateway-${var.environment}"

  extra_tags = {
    tag_version = 2
    iac         = "true"
    environment = "${var.environment}"
  }

  tags = "${merge(var.tags, local.extra_tags)}"
}

resource "azurerm_resource_group" "rg_vnet" {
  name     = "${var.vnet_resource_group_name}"
  location = "${var.location}"
  tags     = "${local.tags}"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.vnet_name}"
  location            = "${azurerm_resource_group.rg_vnet.location}"
  address_space       = ["${local.vnet_address_space}"]
  resource_group_name = "${azurerm_resource_group.rg_vnet.name}"
  tags                = "${local.tags}"
}

# Network security groups are not created and subnets are not associated with security groups on purpose.
# See README.md for more info.

resource "azurerm_subnet" "user_subnet" {
  name                 = "${local.vnet_user_subnet_names[count.index]}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  resource_group_name  = "${azurerm_resource_group.rg_vnet.name}"
  address_prefix       = "${local.vnet_user_subnet_address_spaces[count.index]}"
  count                = "${length(local.vnet_user_subnet_names)}"
}

resource "azurerm_subnet" "default_gateway_subnet" {
  count = "${var.include_gateways_for_vpn_tunnel || var.include_vpn_connection ? 1 : 0 }"

  # the gateway subnet has a name that is fixed by Azure
  name                 = "GatewaySubnet"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  resource_group_name  = "${azurerm_resource_group.rg_vnet.name}"
  address_prefix       = "${local.default_gateway_subnet_address_space}"

  # assigning security groups to the GatewaySubnet is not supported, do not specify it. If you do, very good chances are
  # that the gateway won't work
}

resource "azurerm_public_ip" "vnet_gateway_public_ip" {
  count                        = "${var.include_gateways_for_vpn_tunnel || var.include_vpn_connection ? 1 : 0 }"
  name                         = "${local.vnet_gateway_public_ip_name}"
  location                     = "${azurerm_resource_group.rg_vnet.location}"
  resource_group_name          = "${azurerm_resource_group.rg_vnet.name}"
  public_ip_address_allocation = "Dynamic"
  idle_timeout_in_minutes      = 5
  tags                         = "${local.tags}"
}

resource "azurerm_local_network_gateway" "onprem" {
  count               = "${var.include_gateways_for_vpn_tunnel || var.include_vpn_connection ? 1 : 0 }"
  name                = "${local.local_network_gateway["name"]}"
  resource_group_name = "${azurerm_resource_group.rg_vnet.name}"
  location            = "${azurerm_resource_group.rg_vnet.location}"
  gateway_address     = "${local.local_network_gateway["public_ip_address"]}"
  address_space       = ["${local.local_network_gateway["local_ip_range"]}"]
}

resource "azurerm_virtual_network_gateway" "vnet_gateway" {
  count               = "${var.include_gateways_for_vpn_tunnel || var.include_vpn_connection ? 1 : 0 }"
  name                = "${local.vnet_gateway_name}"
  location            = "${azurerm_resource_group.rg_vnet.location}"
  resource_group_name = "${azurerm_resource_group.rg_vnet.name}"
  type                = "Vpn"
  sku                 = "Basic"
  vpn_type            = "RouteBased"
  tags                = "${local.tags}"

  ip_configuration {
    public_ip_address_id          = "${azurerm_public_ip.vnet_gateway_public_ip.id}"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = "${azurerm_subnet.default_gateway_subnet.id}"
  }
}

resource "azurerm_virtual_network_gateway_connection" "vpn_connection" {
  name                       = "${local.vpn_connection_name}"
  location                   = "${azurerm_resource_group.rg_vnet.location}"
  resource_group_name        = "${azurerm_resource_group.rg_vnet.name}"
  type                       = "IPsec"
  virtual_network_gateway_id = "${azurerm_virtual_network_gateway.vnet_gateway.id}"
  local_network_gateway_id   = "${azurerm_local_network_gateway.onprem.id}"

  shared_key = "${var.vpn_connection_shared_key}"
  tags       = "${local.tags}"
}

data "azurerm_public_ip" "vnet_gateway_public_ip" {
  count               = "${var.include_gateways_for_vpn_tunnel || var.include_vpn_connection ? 1 : 0 }"
  name                = "${azurerm_public_ip.vnet_gateway_public_ip.name}"
  resource_group_name = "${azurerm_resource_group.rg_vnet.name}"
  depends_on          = ["azurerm_virtual_network_gateway.vnet_gateway"]
}

resource "azurerm_dns_a_record" "vnet_gateway" {
  count               = "${var.include_gateways_for_vpn_tunnel || var.include_vpn_connection ? 1 : 0 }"
  name                = "${local.gateway_dns_a_record}"
  zone_name           = "${local.azure_dns_zone}"
  resource_group_name = "${local.azure_dns_zone_resource_group_name}"
  ttl                 = 300
  records             = ["${data.azurerm_public_ip.vnet_gateway_public_ip.ip_address}"]
}
