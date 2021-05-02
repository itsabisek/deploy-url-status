variable "sa_creds" {
  type        = string
  description = "Absolute path of the tf service account json"
}

variable "gcp_project" {
  type        = string
  description = "Name of the gcp project under which to create the resource"
}

variable "gcp_region" {
  type        = string
  description = "Default region for the resource"
  default     = "asia-southeast1"
}

variable "gcp_zone" {
  type        = string
  description = "Default zone for the resource"
  default     = "asia-southeast1-b"
}

variable "instance_prefix" {
  type        = string
  description = "Prefix that will be applied to all instances"
  default     = "backend"
}

variable "vpc_name" {
  type        = string
  description = "Name for the vpc"
  default     = "backend-central"
}