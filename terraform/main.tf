provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}

provider "helm" {
  kubernetes {
    host                   = module.aks.kube_config["host"]
    client_certificate     = base64decode(module.aks.kube_config["client_certificate"])
    client_key             = base64decode(module.aks.kube_config["client_key"])
    cluster_ca_certificate = base64decode(module.aks.kube_config["cluster_ca_certificate"])
  }
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

module "network" {
  source              = "./modules/network"
  vnet_name           = var.vnet_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_name         = var.subnet_name
  address_prefixes    = var.address_prefixes
  tags                = var.tags
}

module "acr" {
  source              = "./modules/acr"
  acr_name            = var.acr_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = var.sku
  tags                = var.tags
}

module "aks" {
  source              = "./modules/aks"
  cluster_name        = var.cluster_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "aks-${random_string.suffix.result}"
  node_count          = var.node_count
  vm_size             = var.vm_size
  service_cidr        = var.service_cidr
  dns_service_ip      = var.dns_service_ip
  docker_bridge_cidr  = var.docker_bridge_cidr
  tags                = var.tags
}


# NGINX Ingress Controller Helm Release
resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "ingress-nginx"

  create_namespace = true

  values = [
    file("helm-values.yaml")  # This is where we reference your helm-values.yaml
  ]
}



output "kube_config" {
  value = module.aks.kube_config
}