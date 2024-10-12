module "naming" {
  source  = "TaleLearnCode/naming/azurerm"
  version = "0.0.2-pre"

  resource_type  = "storage_account"
  name_prefix    = var.name_prefix
  name_suffix    = var.name_suffix
  srv_comp_abbr  = var.srv_comp_abbr
  custom_name    = var.custom_name
  location       = var.location
  environment    = var.environment
}


resource "azurerm_storage_account" "target" {
  name                = module.naming.resource_name
  resource_group_name = var.resource_group_name
  location            = var.location

  access_tier              = var.account_kind == "BlockBlobStorage" && var.account_tier == "Premium" ? null : var.access_tier
  account_tier             = var.account_tier
  account_kind             = var.account_kind
  account_replication_type = var.account_replication_type

  min_tls_version                 = var.min_tls_version
  allow_nested_items_to_be_public = var.allow_nested_items_to_be_public
  public_network_access_enabled   = var.public_network_access_enabled
  shared_access_key_enabled       = var.shared_access_key_enabled
  large_file_share_enabled        = var.account_kind != "BlockBlobStorage" && contains(["LRS", "ZRS"], var.account_replication_type)

  sftp_enabled                      = var.sftp_enabled
  nfsv3_enabled                     = var.nfsv3_enabled
  is_hns_enabled                    = var.nfsv3_enabled || var.sftp_enabled ? true : var.is_hns_enabled
  https_traffic_only_enabled        = var.nfsv3_enabled ? false : var.https_traffic_only_enabled
  cross_tenant_replication_enabled  = var.cross_tenant_replication_enabled
  infrastructure_encryption_enabled = var.infrastructure_encryption_enabled

  dynamic "identity" {
    for_each = var.identity_type == null ? [] : ["enabled"]
    content {
      type         = var.identity_type
      identity_ids = endswith(var.identity_type, "UserAssigned") ? var.identity_ids : null
    }
  }

  dynamic "static_website" {
    for_each = var.static_website_config == null ? [] : ["enabled"]
    content {
      index_document     = var.static_website_config.index_document
      error_404_document = var.static_website_config.error_404_document
    }
  }

  dynamic "custom_domain" {
    for_each = var.custom_domain_name != null ? ["enabled"] : []
    content {
      name          = var.custom_domain_name
      use_subdomain = var.use_subdomain
    }
  }

  dynamic "blob_properties" {
    for_each = (
      var.account_kind != "FileStorage" && (var.storage_blob_data_protection != null || length(var.storage_blob_cors_rules) > 0) ? ["enabled"] : []
    )

    content {
      change_feed_enabled      = var.nfsv3_enabled || var.sftp_enabled ? false : var.storage_blob_data_protection.change_feed_enabled
      versioning_enabled       = var.nfsv3_enabled || var.sftp_enabled ? false : var.storage_blob_data_protection.versioning_enabled
      last_access_time_enabled = var.nfsv3_enabled || var.sftp_enabled ? false : var.storage_blob_data_protection.last_access_time_enabled

      dynamic "cors_rule" {
        for_each = var.storage_blob_cors_rules
        content {
          allowed_headers    = cors_rule.value.allowed_headers
          allowed_methods    = cors_rule.value.allowed_methods
          allowed_origins    = cors_rule.value.allowed_origins
          exposed_headers    = cors_rule.value.exposed_headers
          max_age_in_seconds = cors_rule.value.max_age_in_seconds
        }
      }

      dynamic "delete_retention_policy" {
        for_each = var.storage_blob_data_protection.delete_retention_policy_in_days > 0 ? ["enabled"] : []
        content {
          days = var.storage_blob_data_protection.delete_retention_policy_in_days
        }
      }

      dynamic "container_delete_retention_policy" {
        for_each = var.storage_blob_data_protection.container_delete_retention_policy_in_days > 0 ? ["enabled"] : []
        content {
          days = var.storage_blob_data_protection.container_delete_retention_policy_in_days
        }
      }

      dynamic "restore_policy" {
        for_each = local.point_in_time_restore_enabled ? ["enabled"] : []
        content {
          days = var.storage_blob_data_protection.container_delete_retention_policy_in_days - 1
        }
      }
    }
  }

  dynamic "queue_properties" {
    for_each = var.queue_logging_properties != null && contains(["Storage", "StorageV2"], var.account_kind) ? ["enabled"] : []
    content {
      logging {
        delete                = var.queue_logging_properties.delete
        read                  = var.queue_logging_properties.read
        write                 = var.queue_logging_properties.write
        version               = var.queue_logging_properties.version
        retention_policy_days = var.queue_logging_properties.retention_policy_days
      }
    }
  }

  dynamic "share_properties" {
    for_each = var.file_share_cors_rules != null || var.file_share_retention_policy_in_days != null || var.file_share_properties_smb != null ? ["enabled"] : []
    content {
      dynamic "cors_rule" {
        for_each = var.file_share_cors_rules != null ? ["enabled"] : []
        content {
          allowed_headers    = var.file_share_cors_rules.allowed_headers
          allowed_methods    = var.file_share_cors_rules.allowed_methods
          allowed_origins    = var.file_share_cors_rules.allowed_origins
          exposed_headers    = var.file_share_cors_rules.exposed_headers
          max_age_in_seconds = var.file_share_cors_rules.max_age_in_seconds
        }
      }

      dynamic "retention_policy" {
        for_each = var.file_share_retention_policy_in_days != null ? ["enabled"] : []
        content {
          days = var.file_share_retention_policy_in_days
        }
      }

      dynamic "smb" {
        for_each = var.file_share_properties_smb != null ? ["enabled"] : []
        content {
          authentication_types            = var.file_share_properties_smb.authentication_types
          channel_encryption_type         = var.file_share_properties_smb.channel_encryption_type
          kerberos_ticket_encryption_type = var.file_share_properties_smb.kerberos_ticket_encryption_type
          versions                        = var.file_share_properties_smb.versions
          multichannel_enabled            = var.file_share_properties_smb.multichannel_enabled
        }
      }
    }
  }

  dynamic "azure_files_authentication" {
    for_each = var.file_share_authentication != null ? ["enabled"] : []
    content {
      directory_type = var.file_share_authentication.directory_type
      dynamic "active_directory" {
        for_each = var.file_share_authentication.directory_type == "AD" ? [var.file_share_authentication.active_directory] : []
        iterator = ad
        content {
          storage_sid         = ad.value.storage_sid
          domain_name         = ad.value.domain_name
          domain_sid          = ad.value.domain_sid
          domain_guid         = ad.value.domain_guid
          forest_name         = ad.value.forest_name
          netbios_domain_name = ad.value.netbios_domain_name
        }
      }
    }
  }

  dynamic "network_rules" {
    for_each = var.nfsv3_enabled ? ["enabled"] : []
    content {
      default_action             = "Deny"
      bypass                     = var.network_bypass
      ip_rules                   = local.storage_ip_rules
      virtual_network_subnet_ids = var.subnet_ids
      dynamic "private_link_access" {
        for_each = var.private_link_access
        content {
          endpoint_resource_id = private_link_access.value.endpoint_resource_id
          endpoint_tenant_id   = private_link_access.value.endpoint_tenant_id
        }
      }
    }
  }

  tags = var.tags

  lifecycle {
    precondition {
      condition     = var.account_tier != "Premium" || !local.point_in_time_restore_enabled
      error_message = "Point in time restore is not supported with Premium Storage Accounts."
    }
  }
}