region = "us-east4"

zone = "us-east4-b"

environment_name = "green"

default_bucket_location = "US"

subnet_names = [
  "k8s-nodes-1",
  "k8s-nodes-2",
  "k8s-nodes-3",
  "k8s-nodes-4",
]

# master range 10.24.0.0/16 (address space for K8s nodes, 253 max)
subnet_cidrs = [
  "10.24.0.0/24",
  "10.24.1.0/24",
  "10.24.2.0/24",
  "10.24.3.0/24",
]

secondary_ip_range_gke_cluster_pods_names = [
  "k8s-pods-1",
  "k8s-pods-2",
  "k8s-pods-3",
  "k8s-pods-4",
]

# the IP range must accomodate at least (number of nodes x 256 pods per node) IP addresses
# so, if the node ip range is /24, the pod ip range should be /16
secondary_ip_range_gke_cluster_pods_cidrs = [
  "10.26.0.0/16",
  "10.27.0.0/16",
  "10.28.0.0/16",
  "10.29.0.0/16",
]

secondary_ip_range_gke_cluster_services_names = [
  "k8s-svcs-1",
  "k8s-svcs-2",
  "k8s-svcs-3",
  "k8s-svcs-4",
]

# master range 10.26.0.0/16 (address space for K8s services, 1022 max)
secondary_ip_range_gke_cluster_services_cidrs = [
  "10.25.0.0/22",
  "10.25.4.0/22",
  "10.25.8.0/22",
  "10.25.12.0/22",
]

vpn_tunnel_id = "d-vpn-tunnel-1"

onprem_device_public_ip = "65.254.28.67"

onprem_device_link_local_ip = "169.254.24.2"

onprem_peer_asn = "6501"

cloud_router_link_local_ip = "169.254.24.1"

cloud_router_asn = "65024"

sonicwall_user = "admin"

sonicwall_passwd = "replace_me_with_actual_password"
