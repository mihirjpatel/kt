

variable "region" {
  type        = "string"
  description = "GCP region in which to create the project"
}

variable "zone" {
  type        = "string"
  description = "GCP zone in which to create the project"
}


variable "subnet_names" {
  type        = "list"
  description = "The list of subnet names"
}

variable "subnet_cidrs" {
  type        = "list"
  description = "The list of address ranges for subnets"
}


variable "project_remote_state_config" {
  type        = "map"
  description = "Configuration values to access the remote TF state of the project"
}



variable "vpc_remote_state_config" {
  type        = "map"
  description = "Configuration values to access the remote TF state of the vpc"
}



variable "vpn_tunnel_id" {
  type        = "string"
  description = "The unique ID (name) of the VPN tunnel (e.g. d-vpn-tunnel-1). Should be the same on the on-prem side"
}



variable "onprem_device_public_ip" {
  type        = "string"
  description = "The public IP address for the on-prem router"
}

variable "onprem_device_link_local_ip" {
  type        = "string"
  description = "The link-local IP address for the on-prem router"
}

variable "onprem_peer_asn" {
  type        = "string"
  description = "The ASN for the on-prem router"
}

variable "cloud_router_link_local_ip" {
  type        = "string"
  description = "The link-local IP address for the GCP cloud router (e.g. 169.254.1.1)"
}

variable "cloud_router_asn" {
  type        = "string"
  description = "The ASN for the cloud router"
}

variable "vpn_connection_shared_key" {
  type        = "string"
  description = "The shared secret key for the VPN tunnel"
}