
output "acr_id" {
  description = "The ID of the Azure Container Registry"
  value       = azurerm_container_registry.acr.id
}

output "acr_name" {
  description = "The name of the Azure Container Registry"
  value       = azurerm_container_registry.acr.name
}

output "login_server" {
  description = "The login server URL of the Azure Container Registry"
  value       = azurerm_container_registry.acr.login_server
}

output "acr_identity_id" {
  description = "The ID of the user-assigned identity for ACR"
  value       = length(azurerm_user_assigned_identity.acr_identity) > 0 ? azurerm_user_assigned_identity.acr_identity[0].id : null
}

output "acr_identity_principal_id" {
  description = "The principal ID of the user-assigned identity for ACR"
  value       = length(azurerm_user_assigned_identity.acr_identity) > 0 ? azurerm_user_assigned_identity.acr_identity[0].principal_id : null
}