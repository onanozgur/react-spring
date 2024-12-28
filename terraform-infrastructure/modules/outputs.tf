output "resource_group_name" {
  value = module.resource_group.resource_group_name
}

output "location" {
  value = module.resource_group.location
}

output "vnet_id" {
  value = module.networking.vnet_id
}

output "backend_subnet_id" {
  value = module.networking.backend_subnet_id
}

output "frontend_subnet_id" {
  value = module.networking.frontend_subnet_id
}

output "app_service_plan_id" {
  value = module.compute.app_service_plan_id
}

output "backend_app_service_id" {
  value = module.compute.backend_app_service_id
}

output "frontend_app_service_id" {
  value = module.compute.frontend_app_service_id
}

output "storage_account_id" {
  value = module.storage.storage_account_id
}
