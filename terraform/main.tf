# terraform/main.tf
# Generate a random suffix for unique resource names
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# Create a Key Vault for storing secrets
resource "azurerm_key_vault" "kv" {
  name                        = "kv-aks-${random_string.suffix.result}"
  location                    = var.location
  resource_group_name         = azurerm_resource_group.rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = var.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                    = "standard"

  # Allow Terraform to manage secrets during deployment
  access_policy {
    tenant_id = var.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Purge"
    ]
    key_permissions = [
      "Get", "List", "Create", "Delete"
    ]
    certificate_permissions = [
      "Get", "List", "Create", "Delete"
    ]
  }

  tags = var.tags
}

# Store ACR admin credentials in Key Vault (if needed)
resource "azurerm_key_vault_secret" "acr_password" {
  name         = "acr-password"
  value        = "dummy-placeholder"  # Will be replaced with actual password by admins if admin auth is enabled later
  key_vault_id = azurerm_key_vault.kv.id
}

# Create a Log Analytics workspace for centralized logging
resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-aks-${random_string.suffix.result}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = var.log_analytics_sku
  retention_in_days   = var.log_retention_in_days
  tags                = var.tags
}

# Get current Azure client configuration
data "azurerm_client_config" "current" {}

# Create Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Network Module
module "network" {
  source                 = "./modules/network"
  vnet_name              = var.vnet_name
  address_space          = var.address_space
  location               = var.location
  resource_group_name    = azurerm_resource_group.rg.name
  aks_subnet_name        = var.aks_subnet_name
  aks_address_prefixes   = var.aks_address_prefixes
  appgw_subnet_name      = var.appgw_subnet_name
  appgw_address_prefixes = var.appgw_address_prefixes
  tags                   = var.tags
}

# ACR Module
module "acr" {
  source                     = "./modules/acr"
  acr_name                   = "${var.acr_name}${random_string.suffix.result}"
  location                   = var.location
  resource_group_name        = azurerm_resource_group.rg.name
  sku                        = var.acr_sku
  aks_subnet_id              = module.network.aks_subnet_id
  allowed_cidr_block         = var.address_space[0]  # Allow all VNet CIDR
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
  tags                       = var.tags
}

# AKS Module
module "aks" {
  source                      = "./modules/aks"
  cluster_name                = var.cluster_name
  location                    = var.location
  resource_group_name         = azurerm_resource_group.rg.name
  dns_prefix                  = "aks-${random_string.suffix.result}"
  kubernetes_version          = var.kubernetes_version
  aks_subnet_id               = module.network.aks_subnet_id
  node_count                  = var.node_count
  vm_size                     = var.vm_size
  os_disk_size_gb             = var.os_disk_size_gb
  os_disk_type                = var.os_disk_type
  enable_auto_scaling         = var.enable_auto_scaling
  min_count                   = var.min_count
  max_count                   = var.max_count
  service_cidr                = var.service_cidr
  dns_service_ip              = var.dns_service_ip
  docker_bridge_cidr          = var.docker_bridge_cidr
  log_analytics_workspace_name = "law-aks-${random_string.suffix.result}"
  enable_defender             = true
  log_analytics_sku           = var.log_analytics_sku
  log_retention_in_days       = var.log_retention_in_days
  tags                        = var.tags
}

# Application Gateway Module
module "appgw" {
  source                     = "./modules/appgw"
  appgw_name                 = var.appgw_name
  location                   = var.location
  resource_group_name        = azurerm_resource_group.rg.name
  appgw_subnet_id            = module.network.appgw_subnet_id
  sku_name                   = var.appgw_sku_name
  sku_tier                   = var.appgw_sku_tier
  capacity                   = var.appgw_capacity
  enable_private_frontend    = false  # Change to true for fully private setup
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
  tags                       = var.tags
}

# Role assignment for AKS to pull from ACR
resource "azurerm_role_assignment" "acr_pull" {
  principal_id                     = module.aks.kubelet_identity_object_id
  role_definition_name             = "AcrPull"
  scope                            = module.acr.acr_id
  skip_service_principal_aad_check = true
}

# Role assignment for Application Gateway Ingress Controller
resource "azurerm_role_assignment" "agic_contributor" {
  principal_id                     = module.aks.kubelet_identity_object_id
  role_definition_name             = "Contributor"
  scope                            = module.appgw.appgw_id
  skip_service_principal_aad_check = true
}

# Key Vault access policy for AKS
resource "azurerm_key_vault_access_policy" "aks_kv_access" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = var.tenant_id
  object_id    = module.aks.kubelet_identity_object_id

  secret_permissions = [
    "Get", "List"
  ]
}