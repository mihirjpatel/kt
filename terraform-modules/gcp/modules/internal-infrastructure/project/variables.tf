

variable "region" {
  type        = "string"
  description = "GCP region in which to create the project"
}

variable "zone" {
  type        = "string"
  description = "GCP zone in which to create the project"
}


variable "billing_account" {
  type        = "string"
  description = "Organization's billing account ID in GCP to be used for the project being created"
}
variable "folder_id" {
  type        = "string"
  description = "ID of the parent folder in which to create the project"
}


variable "project_name" {
  type        = "string"
  description = "Name of the project to be created"
}

variable "project_services" {
  type        = "list"
  description = "The list of Google Cloud APIs to enable on the project"

  default = [
    "container.googleapis.com",
    "containerregistry.googleapis.com",
    "iam.googleapis.com",
  ]
}
