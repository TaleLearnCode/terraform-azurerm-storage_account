# #############################################################################
# Create the storage container
# #############################################################################

resource "azurerm_storage_container" "containers" {
  for_each = var.containers != null && length(var.containers) > 0 ? var.containers : {}
  name                  = each.key
  storage_account_name  = module.naming.resource_name
  container_access_type = each.value.container_access_type
  depends_on = [ azurerm_storage_account.target ]
}

data "azurerm_storage_containers" "containers" {
  storage_account_id = azurerm_storage_account.target.id
  depends_on = [ azurerm_storage_container.containers ]
}