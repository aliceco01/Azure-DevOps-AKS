provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
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
  private_endpoint    = true
}

module "appgw" {
  source              = "./modules/appgw"
  appgw_name          = var.appgw_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  appgw_subnet_id     = module.network.appgw_subnet_id
  ssl_certificate_password = var.ssl_certificate_password
  tags                = var.tags
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
  appgw_subnet_cidr          = var.appgw_subnet_prefix
  api_server_authorized_ip_ranges = var.api_server_authorized_ip_ranges
  rbac_enabled               = var.rbac_enabled
  ingress_application_gateway_enabled = var.ingress_application_gateway_enabled
  enable_private_cluster     = true
  tags                       = var.tags
}
