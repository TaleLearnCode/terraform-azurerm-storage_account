# #############################################################################
# Create the storage tables
# #############################################################################

resource "azure_storage_table" "tables" {
  count                = length(var.tables)
  name                 = var.tables[count.index]
  storage_account_name = module.naming.resource_name
  depends_on = [ azurerm_storage_account.target ]
}