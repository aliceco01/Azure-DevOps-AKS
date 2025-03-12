
# Get details about the current Azure user (used for tenant_id)
data "azurerm_client_config" "current" {}

# Fetch the latest SSL certificate from Azure Key Vault
data "azurerm_key_vault_certificate" "appgw_cert" {
  name         = "appgw-cert"
  key_vault_id = azurerm_key_vault.aks_pipeline_keyvault.id
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# 🔹 Create the Key Vault (if not already created)
resource "azurerm_key_vault" "aks_pipeline_keyvault" {
  name                        = "aks-pipeline-keyvault"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  sku_name                    = "standard"
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  enable_rbac_authorization   = true
}

module "network" {
  source              = "./modules/network"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  vnet_name           = var.vnet_name
  vnet_address_space  = var.vnet_address_space
  aks_subnet_name     = var.aks_subnet_name
  aks_subnet_prefix   = var.aks_subnet_prefix
  appgw_subnet_name   = var.appgw_subnet_name
  appgw_subnet_prefix = var.appgw_subnet_prefix
}

module "acr" {
  source              = "./modules/acr"
  acr_name            = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  tags                = var.tags
}
module "appgw" {
  source                    = "./modules/appgw"
  appgw_name                = var.appgw_name
  resource_group_name       = azurerm_resource_group.rg.name
  location                  = var.location
  appgw_subnet_id           = module.network.appgw_subnet_id
  key_vault_id              = azurerm_key_vault.aks_pipeline_keyvault.id
  ssl_certificate_secret_id = data.azurerm_key_vault_certificate.appgw_cert.secret_id  # ✅ Fix applied
  tags                      = var.tags
}

module "aks" {
  source                     = "./modules/aks"
  aks_cluster_name           = var.aks_cluster_name
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = var.location
  aks_subnet_id              = module.network.aks_subnet_id
  admin_username             = var.admin_username
  ssh_public_key             = var.ssh_public_key
  client_id                  = var.client_id
  client_secret              = var.client_secret
  appgw_name                 = var.appgw_name
  appgw_id                   = module.appgw.appgw_id
  appgw_subnet_cidr          = var.appgw_subnet_prefix
  api_server_authorized_ip_ranges = var.api_server_authorized_ip_ranges
  rbac_enabled               = var.rbac_enabled
  ingress_application_gateway_enabled = var.ingress_application_gateway_enabled
  tags                       = var.tags
  dns_prefix                 = var.dns_prefix
  node_count                 = var.node_count
  vm_size                    = var.vm_size
  enable_private_cluster     = var.enable_private_cluster
}
