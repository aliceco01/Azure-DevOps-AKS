

output "login_server" {
  description = "The login server URL of the Azure Container Registry"
  value       = azurerm_container_registry.acr.login_server
}

output "admin_username" {
  description = "The admin username for the Azure Container Registry (if admin_enabled = true)"
  value       = azurerm_container_registry.acr.admin_username
  sensitive   = true
}

output "admin_password" {
  description = "The admin password for the Azure Container Registry (if admin_enabled = true)"
  value       = azurerm_container_registry.acr.admin_password
  sensitive   = true
}