resource "azurerm_log_analytics_workspace" "main" {
  name                = var.log_analytics_workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
}

resource "azurerm_monitor_diagnostic_setting" "backend" {
  name                   = "backend-diagnostic"
  target_resource_id     = var.backend_app_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  logs {
    category = "AppServiceHTTPLogs"
    enabled  = true
  }

  metrics {
    category = "AllMetrics"
    enabled  = true
  }
}

resource "azurerm_monitor_diagnostic_setting" "frontend" {
  name                   = "frontend-diagnostic"
  target_resource_id     = var.frontend_app_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  logs {
    category = "AppServiceHTTPLogs"
    enabled  = true
  }

  metrics {
    category = "AllMetrics"
    enabled  = true
  }
}
