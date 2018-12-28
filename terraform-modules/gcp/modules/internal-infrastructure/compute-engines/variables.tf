variable "region" {
  type        = "string"
  description = "GCP region in which to create the compute instance"
  default     = "us-east4"
}

variable "zone" {
  type        = "string"
  description = "GCP zone in which to create the compute instance"
  default     = "us-east4-b"
}


variable "instance_name" {
  type        = "string"
  description = "Name of the compute instance"
}
variable "machine_type" {
  type        = "string"
  description = "Type of GCP Instance to use"
  default     = "n1-standard-1"
}

variable "image_name" {
  type        = "string"
  description = "GCP project to deploy compute instance to"
}
variable "boot_disk_size" {
  type        = "string"
  description = "Size of the Boot Disk"
  default     = 30
}


variable "attached_disk_name" {
  type        = "string"
  description = "Secondary Disk to attach to the instance"
}

variable "metadata_startup_script" {
  type        = "string"
  description = "Script to Execute on Startup -- Each command should be seperated by &&"
}

variable "labels" {
  description = "A mapping of labels to assign to the resource"
  default     = {}
}


variable "project_remote_state_config" {
  type        = "map"
  description = "Configuration values to access the remote TF state of the project"
}



variable "vpc_remote_state_config" {
  type        = "map"
  description = "Configuration values to access the remote TF state of the vpc"
}
