output "resource_group_id" {
  description = "The ID of the resource group"
  value       = azurerm_resource_group.rg.id
}

output "vnet_id" {
  description = "The ID of the Virtual Network"
  value       = module.network.vnet_id
}

output "aks_subnet_id" {
  description = "The ID of the AKS subnet"
  value       = module.network.aks_subnet_id
}

output "appgw_subnet_id" {
  description = "The ID of the Application Gateway subnet"
  value       = module.network.appgw_subnet_id
}

output "acr_id" {
  description = "The ID of the Azure Container Registry"
  value       = module.acr.acr_id
}

output "aks_kube_config" {
  description = "Kubernetes configuration to connect to the AKS cluster"
  value       = module.aks.kube_config
  sensitive   = true
}

output "aks_cluster_id" {
  description = "The ID of the AKS cluster"
  value       = module.aks.cluster_id
}

output "aks_kubelet_identity_object_id" {
  description = "The object ID of the AKS kubelet identity for role assignments"
  value       = module.aks.kubelet_identity_object_id
}

output "appgw_id" {
  description = "The ID of the Application Gateway"
  value       = module.appgw.appgw_id
}