output "storage_account_name" {
  description = "Storage account name — use in K8s Secret"
  value       = module.storage.storage_account_name
}

output "storage_connection_string" {
  description = "Connection string — pipe into K8s Secret via CI/CD"
  value       = module.storage.primary_connection_string
  sensitive   = true
}

output "container_name" {
  description = "Blob container name"
  value       = module.storage.container_name
}
