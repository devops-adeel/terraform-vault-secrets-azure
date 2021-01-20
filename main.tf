/* Copyright (C) Hashicorp, Inc - All Rights Reserved */
/* Unauthorized copying of this file, via any medium is strictly prohibited */
/* Proprietary and confidential */
/* Written by Adeel Ahmad adeel@hashicorp.com, January 2021 */

locals {
  member_group_ids = var.group_ids != [] ? var.group_ids : [vault_identity_group.placeholder.id]
  secret_type = "azure"
}

resource "vault_azure_secret_backend" "default" {
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

data "vault_policy_document" "default" {
  rule {
    path         = "${local.secret_type}/creds/{{identity.groups.names.${local.secret_type}-creds.metadata.env}}-{{identity.groups.names.${local.secret_type}-creds.metadata.service}}"
    capabilities = ["read"]
    description  = "Allow generating credentials"
  }
}

resource "vault_policy" "default" {
  name   = "${local.secret_type}-creds-tmpl"
  policy = data.vault_policy_document.default.hcl
}

resource "vault_identity_group" "default" {
  name             = "${local.secret_type}-creds"
  type             = "internal"
  policies         = ["default", vault_policy.default.name]
  member_group_ids = local.member_group_ids
}

data "vault_identity_group" "default" {
  group_id = vault_identity_group.default.id
}

resource "vault_identity_group" "placeholder" {
  name = "${local.secret_type}-creds-default-group"
  metadata = {
    env     = "dev"
    service = "example"
  }
}
