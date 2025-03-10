provider "azurerm" {
  subscription_id = var.subscription_id  # Ensure this is defined in variables.tf
  features {}
}

# Generate a random suffix for unique resource names
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Network Module
module "network" {
  source              = "./modules/network"
  vnet_name           = var.vnet_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  aks_subnet_name     = var.aks_subnet_name
  aks_address_prefixes = var.aks_address_prefixes
  appgw_subnet_name   = var.appgw_subnet_name
  appgw_address_prefixes = var.appgw_address_prefixes
  tags                = var.tags
}

# ACR Module
module "acr" {
  source              = "./modules/acr"
  acr_name            = var.acr_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name  # Use the created RG
  sku                 = var.sku
  tags                = var.tags
}

# AKS Module
module "aks" {
  source              = "./modules/aks"
  cluster_name        = var.cluster_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name  # Use the created RG
  dns_prefix          = "aks-${random_string.suffix.result}"
  node_count          = var.node_count
  vm_size             = var.vm_size
  service_cidr        = var.service_cidr
  dns_service_ip      = var.dns_service_ip
  aks_subnet_id       = module.network.aks_subnet_id     # Added for private networking
  tags                = var.tags
}

# Application Gateway Module
module "appgw" {
  source              = "./modules/appgw"
  appgw_name          = var.appgw_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name  # Use the created RG
  appgw_subnet_id     = module.network.appgw_subnet_id
}

# Role Assignment for AKS to pull from ACR
resource "azurerm_role_assignment" "acr_pull" {
  principal_id         = module.aks.kubelet_identity_object_id
  role_definition_name = "AcrPull"
  scope                = module.acr.acr_id
}