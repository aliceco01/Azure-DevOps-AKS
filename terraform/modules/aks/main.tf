resource "azurerm_kubernetes_cluster" "example" {
  name                = var.aks_cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = var.vm_size
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

  api_server_authorized_ip_ranges = var.api_server_authorized_ip_ranges

  role_based_access_control {
   enabled = var.rbac_enabled
  }

  ingress_application_gateway {
    enabled     = var.ingress_application_gateway_enabled
    gateway_name = var.appgw_name
    subnet_cidr = var.appgw_subnet_cidr
  }

  linux_profile {
    admin_username = var.admin_username

    ssh_key {
      key_data = var.ssh_public_key
    }
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  tags = var.tags
}