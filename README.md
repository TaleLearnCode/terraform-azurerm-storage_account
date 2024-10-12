# Azure Storage Account Terraform Module

[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md)

This module manages Azure Storage accounts using the [azurerm](https://registry.terraform.io/providers/hashicorp/azurerm/latest) Terraform provider.

## Providers

| Name    | Version |
| ------- | ------- |
| azurerm | ~> 4.1. |

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| Regions | TaleLearnCode/naming/azurerm | ~> .0.0.1-pre |

## Resources

No resources.

## Usage

Documentation coming.

## Inputs

| Name                            | Description                                                                                                         | Type          | Default      | Required |
|---------------------------------|---------------------------------------------------------------------------------------------------------------------|---------------|--------------|----------|
| `resource_group_name`           | The name of the Resource Group in which to create the Storage Account.                                               | `string`      | N/A          | yes      |
| `account_kind`                  | The Kind of the Storage Account. Possible values are 'StorageV2', 'Storage', 'BlobStorage', 'FileStorage', 'BlockBlobStorage', 'StorageV2 (general purpose v2), 'Storage (general purpose v1), 'BlobStorage (blob storage), 'FileStorage (file storage), 'BlockBlobStorage (block blob storage). Defaults to `StorageV2`. | `string`      | `"StorageV2"`| no       |
| `account_tier`                  | The Tier of the Storage Account. Possible values are 'Standard' and 'Premium'. Defaults to `Standard`. For `BlockBlobStorage` kind, only `Premium` is allowed. | `string`      | `"Standard"` | no       |
| `access_tier`                   | The Access Tier of the Storage Account. Possible values are 'Hot' and 'Cool'. Defaults to `Hot`.                     | `string`      | `"Hot"`      | no       |
| `account_replication_type`      | The Replication Type of the Storage Account. Possible values are 'LRS', 'ZRS', 'GRS', 'RAGRS', 'GZRS', 'RAZRS'. Defaults to `LRS`. | `string`      | `"LRS"`      | no       |
| `min_tls_version`               | The minimum TLS version required for the Storage Account. Possible values are 'TLS1_0', 'TLS1_1', 'TLS1_2'. Defaults to `TLS1_2`. | `string`      | `"TLS1_2"`   | no       |
| `allow_nested_items_to_be_public` | Allow or disallow public access to nested items within a public container in the Storage Account. Defaults to `false`. | `bool`        | `false`      | no       |
| `public_network_access_enabled` | Allow or disallow public network access to the Storage Account. Defaults to `true`.                                  | `bool`        | `true`       | no       |
| `shared_access_key_enabled`     | Allow or disallow shared access key for the Storage Account. Defaults to `true`.                                     | `bool`        | `true`       | no       |
| `sftp_enabled`                  | Allow or disallow SFTP access to the Storage Account. Defaults to `false`.                                           | `bool`        | `false`      | no       |
| `nfsv3_enabled`                 | Allow or disallow NFSv3 access to the Storage Account. Defaults to `false`.                                          | `bool`        | `false`      | no       |
| `is_hns_enabled`                | Allow or disallow Hierarchical Namespace access to the Storage Account. Defaults to `false`.                         | `bool`        | `false`      | no       |
| `https_traffic_only_enabled`    | Allow or disallow HTTPS traffic only to the Storage Account. Defaults to `true`.                                     | `bool`        | `true`       | no       |
| `cross_tenant_replication_enabled` | Allow or disallow cross-tenant replication to the Storage Account. Defaults to `false`.                             | `bool`        | `false`      | no       |
| `infrastructure_encryption_enabled` | Allow or disallow infrastructure encryption to the Storage Account. Defaults to `false`.                           | `bool`        | `false`      | no       |
| `identity_type`                 | The type of Managed Service Identity to be used for the Storage Account. Possible values are 'SystemAssigned', 'UserAssigned', 'SystemAssigned, UserAssigned'. Defaults to `SystemAssigned`. | `string`      | `"SystemAssigned"` | no       |
| `identity_ids`                  | The list of User Assigned Managed Service Identity IDs to be used for the Storage Account. Defaults to `[]`.         | `list(string)` | `[]`         | no       |
| `static_website_config`         | The Static Website Configuration for the Storage Account. Defaults to `null`. Can only be set when the `account_kind` is `StorageV2` or `BlockBlobStorage`. | `object`      | `null`       | no       |
| `custom_domain_name`            | The Custom Domain Name for the Storage Account. Defaults to `null`.                                                  | `string`      | `null`       | no       |
| `use_subdomain`                 | Allow or disallow using subdomain for the Custom Domain Name. Defaults to `false`.                                   | `bool`        | `false`      | no       |
| `storage_blob_data_protection`  | The Blob Data Protection Configuration for the Storage Account.                                                      | `object`      | N/A          | no       |
| `storage_blob_cors_rules`       | The list of CORS Rules for the Storage Account.                                                                      | `list(object)` | `[]`         | no       |
| `queue_logging_properties`      | The Queue Properties Logging Configuration for the Storage Account.                                                  | `object`      | `{}`         | no       |
| `file_share_cors_rules`         | The list of CORS Rules for the File Share.                                                                           | `list(object)` | `[]`         | no       |
| `file_share_retention_policy_in_days` | The File Share Retention Policy in days. Defaults to `null`.                                                     | `number`      | `null`       | no       |
| `file_share_properties_smb`     | The File Share Properties SMB Configuration. Defaults to `null`.                                                     | `object`      | `null`       | no       |
| `file_share_authentication`     | The File Share Authentication Configuration. Defaults to `null`.                                                     | `object`      | `null`       | no       |
| `network_bypass`                | The list of network bypass options for the Storage Account.                                                          | `list(string)` | `["logging", "Metrics", "AzureServices"]` | no       |
| `allowed_cidrs`                 | The list of CIDRs allowed to access the Storage Account.                                                             | `list(string)` | `[]`         | no       |
| `subnet_ids`                    | The list of Subnet IDs allowed to access the Storage Account.                                                        | `list(string)` | `[]`         | no       |
| `private_link_access`           | The list of Private Link Access Configuration for the Storage Account.                                               | `list(object)` | `[]`         | no       |

## Outputs

| Name            | Description                                 |
| --------------- | ------------------------------------------- |
| storage_account | The managed Azure Storage account resource. |

# Naming Guidelines

### App Configuration

| Guideline                       |                                         |
| ------------------------------- | --------------------------------------- |
| Resource Type Identifier        | st                                      |
| Scope                           | Global                                  |
| Max Overall Length              | 3 - 24 characters                       |
| Allowed Component Name Length * | 22 characters                           |
| Valid Characters                | Lowercast letters and numbers.          |
| Regex                           | `^[a-z0-9]{3,24}$`                      |

* Allowed Component Name Length is a combination of the `srv_comp_abbr`, `name_prefix`, and `name_suffix` or the `custom_name` if used.