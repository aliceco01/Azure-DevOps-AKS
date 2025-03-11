output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.rg.name
}

output "acr_login_server" {
  description = "The login server of the Azure Container Registry"
  value       = module.acr.acr_login_server
}

output "aks_cluster_name" {
  description = "The name of the AKS cluster"
  value       = module.aks.aks_cluster_name
}

output "appgw_id" {
  description = "The ID of the Application Gateway"
  value       = module.appgw.appgw_id
}