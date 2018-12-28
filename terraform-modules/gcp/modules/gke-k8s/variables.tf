variable "region" {
  type        = "string"
  description = "GCP region in which to create the project"
}

variable "zone" {
  type        = "string"
  description = "GCP zone in which to create the project"
}

variable "shared_vpc_project_remote_state_config" {
  type        = "map"
  description = "Configuration values to access the remote TF state of the shared-vpc project"
}

variable "k8s_cluster_name" {
  type        = "string"
  description = "Name of the Kubernetes cluster"
}

variable "k8s_subnet_name" {
  type        = "string"
  description = "Name of the subnet to place the Kubernetes cluster into"
}

variable "cluster_ipv4_cidr" {
  type        = "string"
  description = "The IP address range of the kubernetes pods in the Kubernetes cluster"
}

variable "k8s_secondary_ip_range_pods" {
  type        = "string"
  description = "Name of the secondary IP range used for Kubernetes pods"
}

variable "k8s_secondary_ip_range_services" {
  type        = "string"
  description = "Name of the secondary IP range used for Kubernetes services"
}

variable "k8s_version" {
  type        = "string"
  description = "Kubernetes master version"
}

variable "k8s_admin_username" {
  type        = "string"
  description = "Name of the Kubernetes admin user"
}

variable "k8s_admin_password" {
  type        = "string"
  description = "Password for the Kubernetes admin user"
}

variable "k8s_node_disk_size_gb" {
  type        = "string"
  description = "The disk size of the VM"
  default     = 100
}

variable "k8s_node_machine_type" {
  type        = "string"
  description = "GCP machine type"
  default     = "n1-standard-1"
}

variable "storage_admin_service_account" {
  type        = "string"
  description = "The name of the service account that has read/write permissions to all buckets in this project"
}

variable "static_web_bucket" {
  type        = "string"
  description = "The name of the GCS bucket where static web content is stored and hosted to the world."
}

variable "default_bucket_location" {
  type        = "string"
  description = "The location of regionally created GCS buckets, usually US"
}

variable "static_web_bucket_force_destroy" {
  default     = true
  description = "A boolean value whether to automatically destroy the static_web_bucket when performing a terraform destroy on the whole project"
}

variable "cluster_deployer_service_account" {
  type        = "string",
  description = "The name of the service account that does the cluster deployment into Kubernetes"
}
