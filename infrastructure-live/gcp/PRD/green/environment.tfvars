region = "us-east4"

zone = "us-east4-b"

default_bucket_location = "US"

environment_name = "green"

subnet_names = [
  "k8s-nodes-1",
  "k8s-nodes-2",
  "k8s-nodes-3",
  "k8s-nodes-4",
]

# master range 10.24.0.0/16 (address space for K8s nodes, 253 max)
subnet_cidrs = [
  "10.24.8.0/24",
  "10.24.9.0/24",
  "10.24.10.0/24",
  "10.24.11.0/24",
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
  "10.34.0.0/16",
  "10.35.0.0/16",
  "10.36.0.0/16",
  "10.37.0.0/16",
]

secondary_ip_range_gke_cluster_services_names = [
  "k8s-svcs-1",
  "k8s-svcs-2",
  "k8s-svcs-3",
  "k8s-svcs-4",
]

# master range 10.26.0.0/16 (address space for K8s services, 1022 max)
secondary_ip_range_gke_cluster_services_cidrs = [
  "10.25.32.0/22",
  "10.25.36.0/22",
  "10.25.40.0/22",
  "10.25.44.0/22",
]
