variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "allowed_ip_ranges" {
  description = "IP ranges allowed to access storage (e.g. AKS outbound IPs)"
  type        = list(string)
  default     = []
}
