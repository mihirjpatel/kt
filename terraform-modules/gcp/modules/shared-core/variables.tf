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

variable "shared_core_project_name" {
  type        = "string"
  description = "Name of the project to be created"
}

variable "folder_id" {
  type        = "string"
  description = "ID of the parent folder in which to create the project"
}

variable "shared_core_project_services" {
  type        = "list"
  description = "The list of Google Cloud APIs to enable on the project"

  default = [
    "container.googleapis.com",
    "containerregistry.googleapis.com",
    "iam.googleapis.com",
    "dns.googleapis.com",
  ]
}

variable "dns_zone_name" {
  type        = "string"
  description = "GCP name of the DNS zone"
}

variable "dns_zone_dns_name" {
  type        = "string"
  description = "The DNS zone to be created"
}

variable "storage_admin_service_account" {
  type        = "string"
  description = "The name of our service account that has rw access to all storage buckets within the shared-core project"
}

variable "gtm_service_account" {
  type        = "string"
  description = "The name of our google tag manager service account. This account has no GCP permissions."
}

variable "helm_repo_bucket" {
  type        = "string"
  description = "The GCS bucket name for our helm repository. Used for application deployments"
}

variable "static_artifacts_bucket" {
  type        = "string"
  description = "The GCS bucket name for our versioned static artifacts repository. Used to locate static assets/web content deployments"
}

variable "tf_state_bucket" {
  type        = "string"
  description = "The GCS bucket name for our terraform modules states."
}
