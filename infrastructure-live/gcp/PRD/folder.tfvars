#folder_name="DEV"
folder_id = "809818108704"

environment_type = "prd"

shared_core_project_remote_state_config = {
  bucket  = "p-artnet-terraform-admin"
  prefix  = "_global/shared-core/terraform.tfstate"
  project = "p-artnet-terraform-admin"
}

shared_vpc_project_remote_state_config = {
  bucket  = "p-artnet-terraform-admin"
  prefix  = "green/shared-vpc/terraform.tfstate"
  project = "p-artnet-terraform-admin"
}

dns_zone_name = "gcp-artnet-com"

dns_zone_dns_name = "gcp.artnet.com."
