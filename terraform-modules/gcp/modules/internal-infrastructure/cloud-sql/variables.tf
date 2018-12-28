

variable "region" {
  type        = "string"
  description = "GCP region in which to create the project"
}

variable "zone" {
  type        = "string"
  description = "GCP zone in which to create the project"
}

variable "project_remote_state_config" {
  type        = "map"
  description = "Configuration values to access the remote TF state of the shared-core project"
}

variable "db_instance_name" {
  type        = "string"
  description = "GCP Cloud SQL Database Instance Name"
}

variable "db_version_type" {
  type        = "string"
  description = "GCP Cloud SQL Database Type and Version - ex. POSTGRES_9_6"
}

variable "db_instance_tier" {
  type        = "string"
  description = "GCP Cloud SQL Database Instance Size - EX. db-custom-2-13312"
}

variable "db_user_name" {
  type        = "string"
  description = "GCP Cloud SQL Database user name to be created on the instance"
}

variable "db_user_password" {
  type        = "string"
  description = "GCP Cloud SQL Database password to be created for the db_user_name user on the instance"
}