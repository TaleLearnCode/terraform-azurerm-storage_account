# #############################################################################
# Outputs
# #############################################################################

output "storage_account" {
  description = "The managed Storage Account resource."
  value       = azurerm_storage_account.target
}