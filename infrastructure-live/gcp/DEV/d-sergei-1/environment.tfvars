region = "us-east4"

zone = "us-east4-b"

environment_name = "green"

default_bucket_location = "US"

subnet_names = [
  "subnet-1",
]

subnet_cidrs = [
  "10.24.101.0/24",
]

secondary_ip_range_gke_cluster_pods_names = []

secondary_ip_range_gke_cluster_pods_cidrs = []

secondary_ip_range_gke_cluster_services_names = []

secondary_ip_range_gke_cluster_services_cidrs = []

vpn_tunnel_id = "d-sergei-1"

onprem_device_public_ip = "65.254.28.67"

onprem_device_link_local_ip = "169.254.101.2"

onprem_peer_asn = "6501"

cloud_router_link_local_ip = "169.254.101.1"

cloud_router_asn = "65101"

sonicwall_user = "sryabkov-adm"

sonicwall_passwd = "replace_me_with_actual_password"
