# Retrieve the current Azure subscription ID dynamically
data "azurerm_client_config" "current" {}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  private_cluster_enabled = true

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = var.vm_size
    vnet_subnet_id = var.aks_subnet_id  # Added for private networking
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    service_cidr      = var.service_cidr
    dns_service_ip    = var.dns_service_ip
    load_balancer_sku = "standard"  # Required for AGIC compatibility
    outbound_type     = "loadBalancer"
  }

  tags = var.tags

  depends_on = [var.aks_subnet_id]  # Ensure subnet exists before AKS creation
}

# Install AGIC using Helm
resource "null_resource" "agic_install" {
  depends_on = [azurerm_kubernetes_cluster.aks]

  provisioner "local-exec" {
    command = <<EOT
      az aks get-credentials --resource-group ${var.resource_group_name} --name ${var.cluster_name}
      helm repo add application-gateway-kubernetes-ingress https://appgwingress.blob.core.windows.net/ingress-azure-helm-package/
      helm repo update
      helm install agic application-gateway-kubernetes-ingress/ingress-azure \
        --namespace kube-system \
        --set appgw.resourceId=$(terraform output -raw appgw_id) \
        --set armAuth.type=servicePrincipal \
        --set armAuth.secretJSON=$(az ad sp create-for-rbac --role Contributor --scopes /subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name} --query '{clientId: appId, clientSecret: password, tenantId: tenant}' --output json)
    EOT
  }
}

# Existing output for kube_config
output "kube_config" {
  value = {
    host                   = azurerm_kubernetes_cluster.aks.kube_config.0.host
    client_certificate     = azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate
    client_key             = azurerm_kubernetes_cluster.aks.kube_config.0.client_key
    cluster_ca_certificate = azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate
  }
}

# Additional output for AGIC or other modules
output "cluster_id" {
  value = azurerm_kubernetes_cluster.aks.id
}

# Output the kubelet identity for role assignments (e.g., ACR pull)
output "kubelet_identity_object_id" {
  value = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}