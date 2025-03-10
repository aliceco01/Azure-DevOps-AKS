resource "azurerm_public_ip" "appgw_pip" {
  name                = "${var.appgw_name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "appgw" {
  name                = var.appgw_name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = "Standard_v2"  # Use Standard_v2 for AGIC compatibility
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "appgw-ip-config"
    subnet_id = var.appgw_subnet_id
  }

  frontend_port {
    name = "frontend-port"
    port = 80
  }

 frontend_ip_configuration {
  name                          = "frontend-ip-config"
  subnet_id                     = var.appgw_subnet_id
  private_ip_address_allocation = "Dynamic"
}


  # Optional: Remove public_ip_address_id and add private IP for fully private setup
  # frontend_ip_configuration {
  #   name                          = "frontend-ip-config"
  #   subnet_id                     = var.appgw_subnet_id
  #   private_ip_address_allocation = "Dynamic"
  # }

  backend_address_pool {
    name = "aks-backend-pool"
  }

  backend_http_settings {
    name                  = "aks-http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 20
  }

  http_listener {
    name                           = "aks-listener"
    frontend_ip_configuration_name = "frontend-ip-config"
    frontend_port_name             = "frontend-port"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "aks-routing-rule"
    rule_type                  = "Basic"
    http_listener_name         = "aks-listener"
    backend_address_pool_name  = "aks-backend-pool"
    backend_http_settings_name = "aks-http-settings"
    priority = 1
  }

  # Enable WAF (optional, requires WAF SKU)
  # waf_configuration {
  #   enabled          = true
  #   firewall_mode    = "Prevention"
  #   rule_set_type    = "OWASP"
  #   rule_set_version = "3.2"
  # }
}

# Output the Application Gateway ID for AGIC
output "appgw_id" {
  value = azurerm_application_gateway.appgw.id
}