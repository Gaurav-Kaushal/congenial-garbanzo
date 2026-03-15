variable "name_prefix" {
  description = "Prefix for storage account name (max 18 chars, lowercase alphanumeric)"
  type        = string

  validation {
    condition     = length(var.name_prefix) <= 18 && can(regex("^[a-z0-9]+$", var.name_prefix))
    error_message = "name_prefix must be <= 18 chars and only lowercase letters/numbers."
  }
}

variable "resource_group_name" {
  description = "Name of the resource group to deploy into"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "replication_type" {
  description = "Storage replication type (LRS, GRS, ZRS)"
  type        = string
  default     = "LRS"

  validation {
    condition     = contains(["LRS", "GRS", "ZRS", "RAGRS"], var.replication_type)
    error_message = "replication_type must be one of: LRS, GRS, ZRS, RAGRS."
  }
}

variable "container_name" {
  description = "Name of the blob container"
  type        = string
  default     = "app-data"
}

variable "soft_delete_retention_days" {
  description = "Days to retain soft-deleted blobs"
  type        = number
  default     = 7
}

variable "allowed_ip_ranges" {
  description = "List of IP ranges allowed to access storage"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
