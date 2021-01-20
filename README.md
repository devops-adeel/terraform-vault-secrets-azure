# Terraform Vault Secrets Azure

Terraform Module to mount Azure Secrets Backend and attach Vault templated policy to it.

## Requirements

The Azure secrets backend must have sufficient permissions to read Azure role information and manage service principals.  The following Azure roles and Azure Active Directory (AAD) permissions are required, regardless of which authentication method is used:

- "Owner" role for the subscription scope
- "Read and write all applications" permission in AAD

In your Azure subscription, your account must have `Microsoft.Authorization/*/Write` access to assign an AD app to a role.

As input a Vault Identity Group is required to be a member of Azure dedicated Identity Group.  It is important that the Identity group supplied has metadata with keys `env` and `service`.

## Providers

| Name | Version |
|------|---------|
| `vault` | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `group_ids` | List of Vault Identity Group Member IDs | `list(any)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| `vault_identity_group` | JSON data of the Vault Identity Group, including list of member entities |

