

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



variable "dns_zone_name" {
  type        = "string"
  description = "The GCP name of the DNS zone (e.g. 'gcp-artnet-dev-com') in which to create an A record for the VPN gateway"
}

variable "dns_zone_dns_name" {
  type        = "string"
  description = "The DNS name of the DNS zone (e.g. 'gcp.artnet-dev.com.') in which to create an A record for the VPN gateway"
}


variable "project_remote_state_config" {
  type        = "map"
  description = "Configuration values to access the remote TF state of the shared-core project"
}


variable "onprem_device_public_ip" {
  type        = "string"
  description = "The public IP address for the on-prem router"
}