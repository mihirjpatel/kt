region = "us-east4"

zone = "us-east4-b"

default_bucket_location = "US"

subnet_names = [
  "k8s-nodes-1",
  "k8s-nodes-2",
]

# master range 10.24.0.0/16 (address space for K8s nodes, 253 max)
subnet_cidrs = [
  "10.24.4.0/24",
  "10.24.5.0/24",
]

secondary_ip_range_gke_cluster_pods_names = [
  "k8s-pods-1",
  "k8s-pods-2",
]

# the IP range must accomodate at least (number of nodes x 256 pods per node) IP addresses
# so, if the node ip range is /24, the pod ip range should be /16
secondary_ip_range_gke_cluster_pods_cidrs = [
  "10.30.0.0/16",
  "10.31.0.0/16",
]

secondary_ip_range_gke_cluster_services_names = [
  "k8s-svcs-1",
  "k8s-svcs-2",
]

# master range 10.26.0.0/16 (address space for K8s services, 1022 max)
secondary_ip_range_gke_cluster_services_cidrs = [
  "10.25.16.0/22",
  "10.25.20.0/22",
]

vpn_tunnel_id = "d-galleries-02"

onprem_device_public_ip = "65.254.28.67"

onprem_device_link_local_ip = "169.254.30.2"

onprem_peer_asn = "6501"

cloud_router_link_local_ip = "169.254.30.1"

cloud_router_asn = "65030"
