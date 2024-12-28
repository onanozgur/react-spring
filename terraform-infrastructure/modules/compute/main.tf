resource "azurerm_app_service_plan" "main" {
  name                = var.app_service_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku {
    tier = "Standard"
    size = "S1"
  }

  kind = "Linux"
}

resource "azurerm_web_app" "backend" {
  name                = var.backend_app_service_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_app_service_plan.main.id

  site_config {
    linux_fx_version       = "DOCKER|${var.backend_container_image}"
    vnet_route_all_enabled = true
  }

  app_settings = {
    SPRING_PROFILES_ACTIVE = "prod"
  }

  virtual_network_subnet_id = var.backend_subnet_id
}

resource "azurerm_web_app" "frontend" {
  name                = var.frontend_app_service_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_app_service_plan.main.id

  site_config {
    linux_fx_version       = "DOCKER|${var.frontend_container_image}"
    vnet_route_all_enabled = true
  }

  app_settings = {
    NODE_ENV = "production"
  }

  virtual_network_subnet_id = var.frontend_subnet_id
}
