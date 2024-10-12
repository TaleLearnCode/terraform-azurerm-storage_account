# #############################################################################
# Outputs
# #############################################################################

output "storage_account" {
  description = "The managed Storage Account resource."
  value       = azurerm_storage_account.target
}

output "storage_containers" {
  description = "The managed Storage Containers resource."
  value       = data.azurerm_storage_containers.containers
}