variable "org_id" {
  type        = "string"
  description = "Organization's ID in GCP"
}

variable "billing_account" {
  type        = "string"
  description = "Organization's billing account ID in GCP to be used for the project being created"
}

variable "region" {
  type        = "string"
  description = "GCP region in which to create the project"
}

variable "zone" {
  type        = "string"
  description = "GCP zone in which to create the project"
}

variable "shared_vpc_project_name" {
  type        = "string"
  description = "Name of the project to be created"
}

variable "folder_id" {
  type        = "string"
  description = "ID of the parent folder in which to create the project"
}

variable "shared_vpc_project_services" {
  type        = "list"
  description = "The list of Google Cloud APIs to enable on the project"

  default = [
    "container.googleapis.com",
    "containerregistry.googleapis.com",
    "iam.googleapis.com",
  ]
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

variable "shared_core_project_remote_state_config" {
  type        = "map"
  description = "Configuration values to access the remote TF state of the shared-core project"
}

variable "vpn_tunnel_id" {
  type        = "string"
  description = "The unique ID (name) of the VPN tunnel (e.g. d-vpn-tunnel-1). Should be the same on the on-prem side"
}

variable "dns_zone_name" {
  type        = "string"
  description = "The GCP name of the DNS zone (e.g. 'gcp-artnet-dev-com') in which to create an A record for the VPN gateway"
}

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

variable "db_subnet_range" {
  type        = "string"
  description = "Subnet where the SQL database resides (for the firewall rule)"
}
