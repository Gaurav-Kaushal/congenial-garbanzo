variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "allowed_ip_ranges" {
  description = "IP ranges allowed to access storage"
  type        = list(string)
  default     = []
}
