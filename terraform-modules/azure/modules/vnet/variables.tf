variable "location" {
  description = "Azure location (eastus, eastus2, etc.) to create the vnet in"
}

variable "environment" {
  description = "Environment (dev, staging, prod, blue, green, sergei, etc.)"
}

# a dictionary of key-value pairs to label the created resources with
variable "tags" {
  type        = "map"
  description = "Tags to associate with the resources"
}

###

variable "vnet_address_space_prefix_x_y" {
  description = "The first two numbers in the x.y.0.0/16 IP range for the vnet (e.g. \"10.31\"). Use a range that doesn't overlap with ranges already in use."
}

variable "include_gateways_for_vpn_tunnel" {
  description = <<EOF
Include resources needed for the VPN tunnel, except the VPN connection (true/false or 1/0)?
If this variable evaluates to false, only basic network resources (resource group, vnet,
and user subnets) will be created/destroyed. If this variable evaluates to true,
resources required to establish the VPN tunnel (local gateway, vnet gateway and some other ones)
will be created, but the VPN connection itself won't be created/destroyed.
EOF
}

variable "include_vpn_connection" {
  description = "Include the VPN connection itself (true/false or 1/0)?"
}

variable "vpn_connection_shared_key" {
  description = "Shared key for the IPSec VPN connection"
}

variable vnet_resource_group_name {
  description = "Name of the resource group for the virtual network"
}

variable vnet_name {
  description = "Name to assign to the virtual network"
}

variable vnet_k8s_subnet_name {
  description = "Name of the subnet for the Kubernetes cluster"
}
