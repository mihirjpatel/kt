variable "sonicwall_host" {
  type        = "string"
  description = "IP address or DNS name of the SonicWall device to use for the SSH admin session"
}

variable "sonicwall_user" {
  type        = "string"
  description = "User name of the SonicWall admin user"
}

variable "sonicwall_passwd" {
  type        = "string"
  description = "Password for the SonicWall admin user"
}

variable "sonicwall_name" {
  type        = "string"
  description = "The name of the SonicWall device. Used to make sure we are configuring the right device"
}

variable "ssh_settings" {
  type        = "string"
  description = "Optional settings to be used when establishing the SSH to the SonicWall device."
  default     = ""
}

variable "subnet_names" {
  type        = "list"
  description = "The list of subnet names"
}

variable "subnet_cidrs" {
  type        = "list"
  description = "The list of address ranges for subnets"
}

variable "secondary_ip_range_gke_cluster_pods_names" {
  type        = "list"
  description = "The list of secondary ip range names to be used for the GKE cluster pods"
}

variable "secondary_ip_range_gke_cluster_pods_cidrs" {
  type        = "list"
  description = "The list of secondary ip range CIDRs to be used for the GKE cluster pods"
}

variable "secondary_ip_range_gke_cluster_services_names" {
  type        = "list"
  description = "The list of secondary ip range names to be used for the GKE cluster services"
}

variable "secondary_ip_range_gke_cluster_services_cidrs" {
  type        = "list"
  description = "The list of secondary ip range CIDRs to be used for the GKE cluster services"
}

# variable "shared_core_project_remote_state_config" {
#   type        = "map"
#   description = "Configuration values to access the remote TF state of the shared-core project"
# }

variable "vpn_tunnel_id" {
  type        = "string"
  description = "The unique ID (name) of the VPN tunnel (e.g. d-vpn-tunnel-1)."
}

# variable "dns_zone_name" {
#   type        = "string"
#   description = "The GCP name of the DNS zone (e.g. 'gcp-artnet-dev-com') in which to create an A record for the VPN gateway"
# }

variable "dns_zone_dns_name" {
  type        = "string"
  description = "The DNS name of the DNS zone (e.g. 'gcp.artnet-dev.com.') in which to create an A record for the VPN gateway"
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
