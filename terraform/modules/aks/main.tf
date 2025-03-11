# terraform/modules/aks/main.tf
resource "azurerm_log_analytics_workspace" "aks" {
  name                = var.log_analytics_workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.log_analytics_sku
  retention_in_days   = var.log_retention_in_days
  tags                = var.tags
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                    = var.cluster_name
  location                = var.location
  resource_group_name     = var.resource_group_name
  dns_prefix              = var.dns_prefix
  kubernetes_version      = var.kubernetes_version
  private_cluster_enabled = true
  
  default_node_pool {
    name                = "system"
    vm_size             = var.vm_size
    vnet_subnet_id      = var.aks_subnet_id
    node_count          = var.node_count
    min_count           = var.min_count
    max_count           = var.max_count
    os_disk_size_gb     = var.os_disk_size_gb
    os_disk_type        = var.os_disk_type
    type                = "VirtualMachineScaleSets"
  }
  
  identity {
    type = "SystemAssigned"
  }
  
  network_profile {
    network_plugin     = "azure"
    network_policy     = "azure"
    dns_service_ip     = var.dns_service_ip
    service_cidr       = var.service_cidr
    load_balancer_sku  = "standard"
  }
  
  role_based_access_control_enabled = true
  
  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.aks.id
  }
  
  tags = var.tags
}

# User node pool for application workloads
resource "azurerm_kubernetes_cluster_node_pool" "user" {
  name                  = "user"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = var.vm_size
  vnet_subnet_id        = var.aks_subnet_id
  node_count            = var.node_count
  min_count             = var.min_count
  max_count             = var.max_count
  os_disk_size_gb       = var.os_disk_size_gb
  os_disk_type          = var.os_disk_type
  node_labels           = {
    "nodepool" = "user"
  }
}

# Simple diagnostic setting
resource "azurerm_monitor_diagnostic_setting" "aks_diagnostics" {
  name                       = "${var.cluster_name}-diagnostics"
  target_resource_id         = azurerm_kubernetes_cluster.aks.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.aks.id
  
  enabled_log {
    category = "kube-apiserver"
  }
  
  enabled_log {
    category = "kube-audit"
  }
  
  metric {
    category = "AllMetrics"
    enabled  = true
  }
}