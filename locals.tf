# #############################################################################
# Define the local variables
# #############################################################################

locals {
  point_in_time_restore_enabled = (
    alltrue([var.storage_blob_data_protection.change_feed_enabled, var.storage_blob_data_protection.versioning_enabled, var.storage_blob_data_protection.container_point_in_time_restore])
    && var.storage_blob_data_protection.delete_retention_policy_in_days > 0
    && var.storage_blob_data_protection.container_delete_retention_policy_in_days > 2
    && !(var.nfsv3_enabled || var.sftp_enabled || var.account_tier == "Premium")
  )
    storage_ip_rules = toset(flatten([for cidr in var.allowed_cidrs : (length(regexall("/3.", cidr)) > 0 ? [cidrhost(cidr, 0), cidrhost(cidr, -1)] : [cidr])]))
}