# terraform/modules/appgw/outputs.tf
output "appgw_id" {
  description = "The ID of the Application Gateway"
  value       = azurerm_application_gateway.appgw.id
}

output "appgw_name" {
  description = "The name of the Application Gateway"
  value       = azurerm_application_gateway.appgw.name
}

output "appgw_public_ip" {
  description = "The public IP address of the Application Gateway"
  value       = azurerm_public_ip.appgw_pip.ip_address
}

output "appgw_backend_pool_id" {
  description = "The ID of the default backend address pool"
  value       = one(azurerm_application_gateway.appgw.backend_address_pool).id
}

output "appgw_http_settings_id" {
  description = "The ID of the HTTP backend settings"
  value       = [for s in azurerm_application_gateway.appgw.backend_http_settings : s.id if s.name == "http-settings"][0]
}

output "appgw_https_settings_id" {
  description = "The ID of the HTTPS backend settings"
  value       = var.ssl_certificate_name != null ? [for s in azurerm_application_gateway.appgw.backend_http_settings : s.id if s.name == "https-settings"][0] : null
}

output "appgw_identity_principal_id" {
  description = "The principal ID of the Application Gateway user-assigned identity"
  value       = azurerm_user_assigned_identity.appgw_identity.principal_id
}