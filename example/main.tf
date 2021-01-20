locals {
  application_name = "terraform-modules-development-azure"
  env              = "dev"
  service          = "web"
  resource_group   = "DefaultResourceGroup-WEU"
}

module "default" {
  source    = "git::https://github.com/devops-adeel/terraform-vault-secrets-azure.git?ref=v0.1.0"
  group_ids = [module.vault_approle.group_id]
}

module "vault_approle" {
  source           = "git::https://github.com/devops-adeel/terraform-vault-approle.git?ref=v0.4.2"
  application_name = local.application_name
  env              = local.env
  service          = local.service
  subscription_id  = var.subscription_id
  tenant_id        = var.tenant_id
}

resource "vault_azure_secret_backend_role" "default" {
  backend = module.default.backend_path
  role    = format("%s-%s", local.env, local.service)
  ttl     = 300
  max_ttl = 600

  azure_roles {
    role_name = "Contributor"
    scope     = "/subscriptions/${var.subscription_id}/resourceGroups/${local.resource_group}"
  }
}

data "vault_azure_access_credentials" "default" {
  backend        = module.default.backend_path
  role           = vault_azure_secret_backend_role.default.role
  validate_creds = true
}

provider "azure" {
  client_id     = data.vault_azure_access_credentials.default.client_id
  client_secret = data.vault_azure_access_credentials.default.client_secret
}

data "azurerm_resource_group" "default" {
  name = local.resource_group
}

resource "azurerm_managed_disk" "default" {
  name                 = local.application_name
  location             = data.azurerm_resource_group.default.location
  resource_group_name  = data.azurerm_resource_group.default.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
}
