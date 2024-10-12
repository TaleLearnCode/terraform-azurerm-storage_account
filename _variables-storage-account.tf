# #############################################################################
# Variables for storage account
# #############################################################################

variable "resource_group_name" {
  type        = string
  description = "The name of the Resource Group in which to create the Storage Account."
}

variable "account_kind" {
  type = string
  default = "StorageV2"
  description = "The Kind of the Storage Account. Possible values are 'StorageV2', 'Storage', 'BlobStorage', 'FileStorage', 'BlockBlobStorage', 'StorageV2 (general purpose v2), 'Storage (general purpose v1), 'BlobStorage (blob storage), 'FileStorage (file storage), 'BlockBlobStorage (block blob storage). Defaults to `StorageV2`."
}

variable "account_tier" {
  type = string
  default = "Standard"
  description = "The Tier of the Storage Account. Possible values are 'Standard' and 'Premium'. Defaults to `Standard`. For `BlockBlobStorage` kind, only `Premium` is allowed."
}

variable "access_tier" {
  type = string
  default = "Hot"
  description = "The Access Tier of the Storage Account. Possible values are 'Hot' and 'Cool'. Defaults to `Hot`."
}

variable "account_replication_type" {
  type = string
  default = "LRS"
  description = "The Replication Type of the Storage Account. Possible values are 'LRS', 'ZRS', 'GRS', 'RAGRS', 'GZRS', 'RAZRS'. Defaults to `LRS`."
}

variable "min_tls_version" {
  type = string
  default = "TLS1_2"
  description = "The minimum TLS version required for the Storage Account. Possible values are 'TLS1_0', 'TLS1_1', 'TLS1_2'. Defaults to `TLS1_2`."
}

variable "allow_nested_items_to_be_public" {
  type = bool
  default = false
  description = "Allow or disallow public access to nested items within a public container in the Storage Account. Defaults to `false`."
}

variable "public_network_access_enabled" {
  type = bool
  default = true
  description = "Allow or disallow public network access to the Storage Account. Defaults to `true`."
}

# TODO: Look at possibility of changing this to default to false
variable "shared_access_key_enabled" {
  type = bool
  default = true
  description = "Allow or disallow shared access key for the Storage Account. Defaults to `true`."
}

variable "sftp_enabled" {
  type = bool
  default = false
  description = "Allow or disallow SFTP access to the Storage Account. Defaults to `false`."
}

variable "nfsv3_enabled" {
  type = bool
  default = false
  description = "Allow or disallow NFSv3 access to the Storage Account. Defaults to `false`."
}

variable "is_hns_enabled" {
  type = bool
  default = false
  description = "Allow or disallow Hierarchical Namespace access to the Storage Account. Defaults to `false`."
}

variable "https_traffic_only_enabled" {
  type = bool
  default = true
  description = "Allow or disallow HTTPS traffic only to the Storage Account. Defaults to `true`."
}

variable "cross_tenant_replication_enabled" {
  type = bool
  default = false
  description = "Allow or disallow cross-tenant replication to the Storage Account. Defaults to `false`."
}

variable "infrastructure_encryption_enabled" {
  type = bool
  default = false
  description = "Allow or disallow infrastructure encryption to the Storage Account. Defaults to `false`."
}

variable "identity_type" {
  type = string
  default = "SystemAssigned"
  description = "The type of Managed Service Identity to be used for the Storage Account. Possible values are 'SystemAssigned', 'UserAssigned', 'SystemAssigned, UserAssigned'. Defaults to `SystemAssigned`."
}

variable "identity_ids" {
  type = list(string)
  default = []
  description = "The list of User Assigned Managed Service Identity IDs to be used for the Storage Account. Defaults to `[]`."
}

variable "static_website_config" {
  type = object({
    index_document     = string
    error_404_document = string
  })
  default = null
  description = "The Static Website Configuration for the Storage Account. Defaults to `null`. Can only be set when the `account_kind` is `StorageV2` or `BlockBlobStorage`."
}

variable "custom_domain_name" {
  type = string
  default = null
  description = "The Custom Domain Name for the Storage Account. Defaults to `null`."
}

variable "use_subdomain" {
  type = bool
  default = false
  description = "Allow or disallow using subdomain for the Custom Domain Name. Defaults to `false`."
}

variable "storage_blob_data_protection" {
  type = object({
    change_feed_enabled                       = optional(bool, false)
    versioning_enabled                        = optional(bool, false)
    last_access_time_enabled                  = optional(bool, false)
    delete_retention_policy_in_days           = optional(number, 0)
    container_delete_retention_policy_in_days = optional(number, 0)
    container_point_in_time_restore           = optional(bool, false)
  })
  default = {
    change_feed_enabled                       = true
    last_access_time_enabled                  = true
    versioning_enabled                        = true
    delete_retention_policy_in_days           = 30
    container_delete_retention_policy_in_days = 30
    container_point_in_time_restore           = true
  }
  description = "The Blob Data Protection Configuration for the Storage Account."
}

variable "storage_blob_cors_rules" {
  type = list(object({
    allowed_headers    = list(string)
    allowed_methods    = list(string)
    allowed_origins    = list(string)
    exposed_headers    = list(string)
    max_age_in_seconds = number
  })
  )
  default = []
  description = "The list of CORS Rules for the Storage Account."
}

variable "queue_logging_properties" {
  type = object({
    read                  = optional(bool, true)
    write                 = optional(bool, true)
    delete                = optional(bool, true)
    version               = optional(string, "1.0")
    retention_policy_days = optional(number, 7)
  })
  default = {}
  description = "The Queue Properties Logging Configuration for the Storage Account."
}

variable "file_share_cors_rules" {
  type = object({
    allowed_headers    = list(string)
    allowed_methods    = list(string)
    allowed_origins    = list(string)
    exposed_headers    = list(string)
    max_age_in_seconds = number
  })
  default = null
  description = "The list of CORS Rules for the File Share." 
}

variable "file_share_retention_policy_in_days" {
  type = number
  default = null
  description = "The File Share Retention Policy in days. Defaults to `null`."
}

variable "file_share_properties_smb" {
  type = object({
    versions                        = optional(list(string), null)
    authentication_types            = optional(list(string), null)
    kerberos_ticket_encryption_type = optional(list(string), null)
    channel_encryption_type         = optional(list(string), null)
    multichannel_enabled            = optional(bool, null)
  })
  default = null
  description = "The File Share Properties SMB Configuration. Defaults to `null`."
}

variable "file_share_authentication" {
  type = object({
    directory_type = string
    active_directory = optional(object({
      storage_sid         = string
      domain_name         = string
      domain_sid          = string
      domain_guid         = string
      forest_name         = string
      netbios_domain_name = string
    }))
  })
  default = null
  description = "The File Share Authentication Configuration. Defaults to `null`."
  validation {
    condition = var.file_share_authentication == null || (
      contains(["AADDS", "AD", ""], try(var.file_share_authentication.directory_type, ""))
    )
    error_message = "`file_share_authentication.directory_type` can only be `AADDS` or `AD`."
  }
  validation {
    condition = var.file_share_authentication == null || (
      try(var.file_share_authentication.directory_type, null) == "AADDS" || (
        try(var.file_share_authentication.directory_type, null) == "AD" &&
        try(var.file_share_authentication.active_directory, null) != null
      )
    )
    error_message = "`file_share_authentication.active_directory` block is required when `file_share_authentication.directory_type` is set to `AD`."
  }
}

variable "network_bypass" {
  type = list(string)
  default = ["logging", "Metrics", "AzureServices"]
  description = "The list of network bypass options for the Storage Account."
}

variable "allowed_cidrs" {
  type = list(string)
  default = []
  description = "The list of CIDRs allowed to access the Storage Account."
}

variable "subnet_ids"  {
  type = list(string)
  default = []
  description = "The list of Subnet IDs allowed to access the Storage Account."
}

variable "private_link_access" {
  type = list(object({
    endpoint_resource_id = string
    endpoint_tenant_id   = string
  }))
  default = []
  description = "The list of Private Link Access Configuration for the Storage Account."
}