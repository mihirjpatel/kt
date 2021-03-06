region = "us-east4"

zone = "us-east4-b"

project_name = "p-internal-infra-01"


environment_name = "green"

default_bucket_location = "US"

subnet_names = [
  "infra-subnet-1",
]

subnet_cidrs = [
  "10.24.97.0/24",
]

vpn_tunnel_id = "p-internal-infra-04"

onprem_device_public_ip = "65.254.28.67"

onprem_device_link_local_ip = "169.254.33.2"

onprem_peer_asn = "6501"

cloud_router_link_local_ip = "169.254.33.1"

cloud_router_asn = "65103"
