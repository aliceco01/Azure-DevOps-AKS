resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name           = "default"
    node_count     = var.node_count
    vm_size        = var.vm_size
    vnet_subnet_id = var.aks_subnet_id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin     = "azure"
    network_policy     = "azure"
    load_balancer_sku  = "standard"
    outbound_type      = "userDefinedRouting"
  }

  ingress_application_gateway {
    gateway_id = var.ingress_application_gateway_enabled ? var.appgw_id : null
  }

  api_server_access_profile {
    authorized_ip_ranges = var.api_server_authorized_ip_ranges
  }

  role_based_access_control_enabled = var.rbac_enabled

  linux_profile {
    admin_username = var.admin_username

    ssh_key {
      key_data = var.ssh_public_key
    }
  }

  tags = var.tags
}
