###

variable "environment" {
  description = "Name of the environment"
  default     = "global"
}

variable "project" {
  description = "The name of the project to record in the tags"
  default     = "DevOps"
}

variable "user_running_terraform" {
  description = "Name of the user running terraform"
}

###

variable "location" {
  description = "Azure location (useast, useast2, uswest, etc.)"
  default     = "eastus"
}

variable "azure_dns_zone" {
  description = "Name of the DNS zone"
  default     = "azure.artnet.com"
}
