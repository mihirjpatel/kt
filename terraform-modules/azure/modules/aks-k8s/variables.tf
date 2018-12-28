variable "location" {
  description = "Azure location (eastus, eastus2, etc.) where the Kubernetes cluster will reside"
}

variable "environment" {
  description = "Environment (dev, staging, prod, blue, green, sergei, etc.)"
}

variable "client_id" {
  description = "Name (GUID) of the Azure AD Service Principal that is used by the Kubernetes cluster to provision/manipulate cloud resources"
}

variable "client_secret" {
  description = "Password for the Azure AD Service Principal specified in the client_id variable"
}

variable "vnet_address_space_prefix_x_y" {
  description = "The first two numbers in the x.y.0.0/16 IP range for the vnet where the Kubernetes cluster will reside."
}

variable "k8s_agent_count" {
  description = "Number of Kubernetes nodes"
}

variable "k8s_ssh_public_key" {
  description = "path/to/filename of the SSH public key"
}

# variable "tfstate_vnet" {
#   type        = "map"
#   description = "config values to read terraform remote state for vnet"
# }

# a dictionary of key-value pairs to label the created resources with
variable "tags" {
  type        = "map"
  description = "Tags to associate with the resources"
}

variable vnet_resource_group_name {
  description = "Name of the resource group for the virtual network in which K8s cluster nodes will reside"
}

variable vnet_name {
  description = "Name of the virtual network in which K8s cluster nodes will reside"
}

variable vnet_k8s_subnet_name {
  description = "Name of the subnet in which K8s cluster nodes will reside"
}
