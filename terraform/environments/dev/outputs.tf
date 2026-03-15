output "storage_account_name" {
  value = module.storage.storage_account_name
}

output "storage_connection_string" {
  value     = module.storage.primary_connection_string
  sensitive = true
}

output "container_name" {
  value = module.storage.container_name
}
