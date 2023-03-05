variable "rg_name" {
  type = string
}

variable "storage_account_name" {
  type = string
}

variable "storage_account_access_key" {
  type      = string
  sensitive = true
}

variable "primary_location" {
  type = string
}

variable "primary_location_abbr" {
  type = string
}

variable "logging_location" {
  type    = string
  default = "West US 2"
}

variable "logging_location_abbr" {
  type    = string
  default = "wus2"
}

variable "project_group" {
  type = string
}

variable "project_name" {
  type = string
}

variable "project_env" {
  type = string
}

variable "tags" {
  description = "The tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "functions_worker_runtime" {
  description = "The language the app is written in."
  type        = string
  default     = "dotnet"
}

variable "website_pull_image_over_vnet" {
  description = "if true, the image is pulled via the inbound ip address of the funcation app."
  type        = bool
  default     = false
}

variable "network_tiers" {
  description = "Custom object used to loop through the network tiers required by the project"
  type        = list(string)
  default     = ["tier1", "tier2", "tier3"]
}

variable "storage_account_primary_connection_string" {
  type      = string
  sensitive = true
}
