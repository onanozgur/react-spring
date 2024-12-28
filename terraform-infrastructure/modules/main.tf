terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "azurerm" {
  features {}
}

module "resource_group" {
  source = "./modules/resource_group"
  resource_group_name = var.resource_group_name
  location            = var.location
}

module "networking" {
  source              = "./modules/networking"
  vnet_name           = var.vnet_name
  backend_subnet_name = var.backend_subnet_name
  frontend_subnet_name = var.frontend_subnet_name
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.location
}

module "compute" {
  source = "./modules/compute"
  app_service_plan_name = var.app_service_plan_name
  backend_app_service_name = var.backend_app_service_name
  frontend_app_service_name = var.frontend_app_service_name
  backend_container_image = var.backend_container_image
  frontend_container_image = var.frontend_container_image
  backend_subnet_id = module.networking.backend_subnet_id
  frontend_subnet_id = module.networking.frontend_subnet_id
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.location
}

module "storage" {
  source              = "./modules/storage"
  storage_account_name = var.storage_account_name
  resource_group_name  = module.resource_group.resource_group_name
  location             = module.resource_group.location
}

module "monitoring" {
  source                  = "./modules/monitoring"
  log_analytics_workspace_name = var.log_analytics_workspace_name
  location                = module.resource_group.location
  resource_group_name     = module.resource_group.resource_group_name
  backend_app_id          = module.compute.backend_app_service_id
  frontend_app_id         = module.compute.frontend_app_service_id
}
