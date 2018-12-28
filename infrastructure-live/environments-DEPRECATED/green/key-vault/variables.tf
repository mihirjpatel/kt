variable "location" {
  description = "Azure location (eastus, eastus2, etc.)"
  default     = "eastus"
}

variable "project" {
  description = "The name of the project to record in the tags, e.g. \"Infrastructure\", \"Identity Server\", etc."
  default     = "DevOps"
}

variable "user_running_terraform" {
  description = "Name of the user running terraform"
}

variable "environment" {
  description = "Environment (dev, staging, prod, blue, green, etc.)"
  default     = "green"
}
