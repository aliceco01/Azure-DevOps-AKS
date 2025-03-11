
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = true
  
  network_rule_set {
    default_action = "Deny"
    
    ip_rule {
      action   = "Allow"
      ip_range = var.allowed_cidr_block
    }
    
  }
  
  # Enable encryption with customer-managed key (if key_vault_id is provided)
  dynamic "encryption" {
    for_each = var.key_vault_key_id != null ? [1] : []
    content {
      key_vault_key_id   = var.key_vault_key_id
      identity_client_id = azurerm_user_assigned_identity.acr_identity[0].client_id
    }
  }
  
  # Identity for encryption and other operations
  dynamic "identity" {
    for_each = var.key_vault_key_id != null ? [1] : []
    content {
      type = "UserAssigned"
      identity_ids = [azurerm_user_assigned_identity.acr_identity[0].id]
    }
  }
  
  # Enable features for security and compliance
    quarantine_policy_enabled = true
  }

# Create user-assigned identity for ACR if key vault encryption is enabled
resource "azurerm_user_assigned_identity" "acr_identity" {
  count               = var.key_vault_key_id != null ? 1 : 0
  name                = "${var.acr_name}-identity"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

# Create diagnostic settings for ACR logs
resource "azurerm_monitor_diagnostic_setting" "acr_diag" {
  count                      = var.log_analytics_workspace_id != null ? 1 : 0
  name                       = "${var.acr_name}-diag"
  target_resource_id         = azurerm_container_registry.acr.id
  log_analytics_workspace_id = var.log_analytics_workspace_id
  
}

resource "azurerm_monitor_diagnostic_setting_log" "acr_log_repository_events" {
  target_resource_id         = azurerm_container_registry.acr.id
  log_analytics_workspace_id = var.log_analytics_workspace_id
  category                   = "ContainerRegistryRepositoryEvents"
  enabled                    = true

  retention_policy {
    enabled = true
    days    = 30
  }
}

resource "azurerm_monitor_diagnostic_setting_log" "acr_log_login_events" {
  target_resource_id         = azurerm_container_registry.acr.id
  log_analytics_workspace_id = var.log_analytics_workspace_id
  category                   = "ContainerRegistryLoginEvents"
  enabled                    = true

  retention_policy {
    enabled = true
    days    = 30
  }
}

resource "azurerm_monitor_diagnostic_setting_metric" "acr_metric_all" {
  target_resource_id         = azurerm_container_registry.acr.id
  log_analytics_workspace_id = var.log_analytics_workspace_id
  category                   = "AllMetrics"
  enabled                    = true

  retention_policy {
    enabled = true
    days    = 30
  }
}