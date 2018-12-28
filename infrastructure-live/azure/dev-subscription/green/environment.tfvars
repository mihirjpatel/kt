environment = "green"

vnet_resource_group_name = "vnet-green-rg"
vnet_name = "vnet-green"
# x.y: must match x.y.0.0/16
vnet_address_space_prefix_x_y = "10.20"
vnet_k8s_subnet_name = "k8s"
location = "eastus"

tags = {
  project = "DevOps"
  owner   = "sryabkov"
}

