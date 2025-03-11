# terraform/modules/appgw/main.tf
# Create public IP for the Application Gateway
resource "azurerm_public_ip" "appgw_pip" {
  name                = "${var.appgw_name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

# Create User Assigned Identity for the Application Gateway
resource "azurerm_user_assigned_identity" "appgw_identity" {
  name                = "${var.appgw_name}-identity"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# Create Application Gateway with WAF
resource "azurerm_application_gateway" "appgw" {
  name                = var.appgw_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  sku {
    name     = var.sku_name
    tier     = var.sku_tier
    capacity = var.capacity
  }

  gateway_ip_configuration {
    name      = "${var.appgw_name}-ip-config"
    subnet_id = var.appgw_subnet_id
  }

  # HTTP Port
  frontend_port {
    name = "http-port"
    port = 80
  }

  # HTTPS Port
  frontend_port {
    name = "https-port"
    port = 443
  }

  # Public Frontend IP Configuration
  frontend_ip_configuration {
    name                 = "public-frontend-ip"
    public_ip_address_id = azurerm_public_ip.appgw_pip.id
  }

  # Private Frontend IP Configuration if subnet is provided
  dynamic "frontend_ip_configuration" {
    for_each = var.enable_private_frontend ? [1] : []
    content {
      name                          = "private-frontend-ip"
      subnet_id                     = var.appgw_subnet_id
      private_ip_address_allocation = "Dynamic"
    }
  }

  # Backend Address Pool
  backend_address_pool {
    name = "default-backend-pool"
  }

  # Backend HTTP Settings - HTTP
  backend_http_settings {
    name                  = "http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30
    probe_name            = "health-probe-http"
  }

  # Backend HTTP Settings - HTTPS
  backend_http_settings {
    name                  = "https-settings"
    cookie_based_affinity = "Disabled"
    port                  = 443
    protocol              = "Https"
    request_timeout       = 30
    probe_name            = "health-probe-https"
  }

  # HTTP Probe
  probe {
    name                = "health-probe-http"
    host                = "127.0.0.1"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
    protocol            = "Http"
    path                = "/"
  }

  # HTTPS Probe
  probe {
    name                = "health-probe-https"
    host                = "127.0.0.1"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
    protocol            = "Https"
    path                = "/"
  }

  # HTTP Listener
  http_listener {
    name                           = "http-listener"
    frontend_ip_configuration_name = "public-frontend-ip"
    frontend_port_name             = "http-port"
    protocol                       = "Http"
  }

  # HTTPS Listener (if SSL certificate is provided)
  dynamic "http_listener" {
    for_each = var.ssl_certificate_name != null ? [1] : []
    content {
      name                           = "https-listener"
      frontend_ip_configuration_name = "public-frontend-ip"
      frontend_port_name             = "https-port"
      protocol                       = "Https"
      ssl_certificate_name           = var.ssl_certificate_name
    }
  }

  # SSL Certificate (if provided)
  dynamic "ssl_certificate" {
    for_each = var.ssl_certificate_name != null && var.key_vault_secret_id != null ? [1] : []
    content {
      name                = var.ssl_certificate_name
      key_vault_secret_id = var.key_vault_secret_id
    }
  }

  # HTTP to HTTPS Redirect Rule (if SSL is enabled)
  dynamic "request_routing_rule" {
    for_each = var.ssl_certificate_name != null ? [1] : []
    content {
      name                       = "http-to-https-redirect"
      rule_type                  = "Basic"
      http_listener_name         = "http-listener"
      redirect_configuration_name = "http-to-https-redirect"
      priority                   = 10
    }
  }

  # HTTPS Routing Rule (if SSL is enabled)
  dynamic "request_routing_rule" {
    for_each = var.ssl_certificate_name != null ? [1] : []
    content {
      name                       = "https-routing-rule"
      rule_type                  = "Basic"
      http_listener_name         = "https-listener"
      backend_address_pool_name  = "default-backend-pool"
      backend_http_settings_name = "https-settings"
      priority                   = 20
    }
  }

  # Default HTTP Routing Rule (if SSL is not enabled)
  dynamic "request_routing_rule" {
    for_each = var.ssl_certificate_name == null ? [1] : []
    content {
      name                       = "default-routing-rule"
      rule_type                  = "Basic"
      http_listener_name         = "http-listener"
      backend_address_pool_name  = "default-backend-pool"
      backend_http_settings_name = "http-settings"
      priority                   = 30
    }
  }

  # HTTP to HTTPS Redirect Configuration
  dynamic "redirect_configuration" {
    for_each = var.ssl_certificate_name != null ? [1] : []
    content {
      name                 = "http-to-https-redirect"
      redirect_type        = "Permanent"
      target_listener_name = "https-listener"
      include_path         = true
      include_query_string = true
    }
  }

  # WAF Configuration for WAF_v2 SKU
  dynamic "waf_configuration" {
    for_each = var.sku_tier == "WAF_v2" ? [1] : []
    content {
      enabled                  = true
      firewall_mode            = var.waf_mode
      rule_set_type            = "OWASP"
      rule_set_version         = "3.2"
      file_upload_limit_mb     = 100
      request_body_check       = true
      max_request_body_size_kb = 128
    }
  }

  # Identity configuration for Key Vault integration
  dynamic "identity" {
    for_each = var.key_vault_secret_id != null ? [1] : []
    content {
      type         = "UserAssigned"
      identity_ids = [azurerm_user_assigned_identity.appgw_identity.id]
    }
  }

  # Prevent unnecessary replacements
  lifecycle {
    ignore_changes = [
      tags,
      backend_address_pool,
      backend_http_settings,
      http_listener,
      probe,
      request_routing_rule,
      redirect_configuration,
      url_path_map,
      ssl_certificate
    ]
  }
}

# Diagnostic settings for Application Gateway
resource "azurerm_monitor_diagnostic_setting" "appgw_diag" {
  count                      = var.log_analytics_workspace_id != null ? 1 : 0
  name                       = "${var.appgw_name}-diag"
  target_resource_id         = azurerm_application_gateway.appgw.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  log_analytics_destination_type = "Dedicated"

  metric {
    category = "AllMetrics"
    enabled  = true

  }

  metric {
    category = "AllMetrics"
    enabled  = true

  }
}